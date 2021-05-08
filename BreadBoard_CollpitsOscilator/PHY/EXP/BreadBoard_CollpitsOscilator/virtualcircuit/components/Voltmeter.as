package virtualcircuit.components{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import virtualcircuit.components.Junction;
	import virtualcircuit.userinterface.StageBuilder;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.Node;
	import virtualcircuit.logic.Utilities;
	import virtualcircuit.logic.collision.*;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.yahoo.astra.fl.charts.LineChart;
	import com.yahoo.astra.fl.charts.series.LineSeries;
	
	public class Voltmeter extends MovieClip{
		
		var blackTarget:Object;
		var redTarget:Object;
		public static var voltageReading:Number;
		var redPin:RedPin;
		var blackPin:BlackPin;
		var	redWire:MovieClip;
		var	blackWire:MovieClip;
		public var volt:VoltBody;
		var prevX:Number;
		var prevY:Number;
		var posX:Number;
		var posY:Number;
		var isDrag:Boolean;
		var isRedDrag:Boolean;
		var isBlackDrag:Boolean;
		var isInContact:Boolean;
		var redHit:Boolean;
		var blackHit:Boolean;
		var gf:GlowFilter;
		var redCollisionList:CollisionList; //Its is a array with the first element being the target and the rest 											 being the elements against which hit should be preformed
		var blackCollisionList:CollisionList;//Its is a array with the first element being the target and the 			 											rest being the elements against which hit should be preformed
		
		/*var timer:Timer=new Timer(1500);
		var VOLT:Number;
		var croArray:Array=new Array();
		public var chartCategoryNames:Array=new Array();
		public var chartDataProvider1:Array=new Array();
		public var dataChart=new LineChart();*/
		
		public function Voltmeter(){
			
			this.isDrag=false;
			this.isRedDrag=false;
			this.isBlackDrag=false;
			this.isInContact=false;
			this.redPin=new RedPin();
			this.redPin.name="Red Pin";
			this.blackPin=new BlackPin();
			this.blackPin.name="Black Pin";
			this.redCollisionList=new CollisionList(this.redPin.pinTop);
			this.blackCollisionList=new CollisionList(this.blackPin.pinTop);
									
			this.volt=new VoltBody();
			this.redWire=new MovieClip();
			this.blackWire=new MovieClip();
			var gf:GlowFilter;
			gf=new GlowFilter(0X660033,1,2,5,3,BitmapFilterQuality.LOW,true,false);//0X660033
			this.redWire.filters=[gf];
			gf=new GlowFilter(0X000000,1,5,8,3,BitmapFilterQuality.LOW,true,false);//0X660033
			this.blackWire.filters=[gf];
			
			this.setVisible(false);
			this.buttonMode=true;
								
			addChild(volt);
			addChild(this.redPin);
			addChild(this.blackPin);
			addChild(redWire);
			addChild(blackWire);
			
			this.scaleX=0.28;
			this.scaleY=0.28;
		
			this.redPin.addEventListener(MouseEvent.MOUSE_DOWN,movePin);
			this.redPin.addEventListener(MouseEvent.MOUSE_UP,stopPin);
			this.blackPin.addEventListener(MouseEvent.MOUSE_DOWN,movePin);
			this.blackPin.addEventListener(MouseEvent.MOUSE_UP,stopPin);
			this.volt.addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
			this.volt.addEventListener(MouseEvent.MOUSE_UP,endDrag);
			
			//timer.addEventListener(TimerEvent.TIMER,timer_Fn);
			//timer.start();
		}
		
		function timer_Fn(e:TimerEvent){
			/*if(this.volt.currText.text=="-----"){
				trace("-----")
			} else{
				trace(VOLT)
			}*/
			if(!isNaN(VOLT)){
				if(dataChart.parent==this.parent){
					this.parent.removeChild(dataChart);
				}
				dataChart=new LineChart();
				if(StageBuilder.croVisible){
					dataChart.visible=true;
				} else{
					dataChart.visible=false;
				}
				croArray.push(VOLT);
				chartCategoryNames.push(croArray.length)
				chartDataProvider1.push(croArray[croArray.length-1]);
				StageBuilder.fn(this,dataChart);
			}
		}
		
		public function startTimer(){
			timer.start();
		}
		
		public function resetTimer(){
			timer.reset();
		}
		
		function beginDrag(e:MouseEvent):void{
			if(e.target is VoltBody){
				e.target.parent.parent.setChildIndex(e.target.parent,e.target.parent.parent.numChildren-1);
				e.target.startDrag();
				this.setSelection(true);
				this.redPin.addEventListener(Event.ENTER_FRAME,startDraw);
				this.blackPin.addEventListener(Event.ENTER_FRAME,startDraw);
				e.target.parent.isDrag=true;
				e.target.parent.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAll);
			}
		}
		
		function endDrag(e:MouseEvent):void{
			if(e.target.parent.parent.hasOwnProperty("boundArea")){
				e.target.stopDrag();
				e.target.parent.isDrag=false;
				this.redPin.dispatchEvent(new Event(Event.ENTER_FRAME));
				this.blackPin.dispatchEvent(new Event(Event.ENTER_FRAME));
				this.redPin.removeEventListener(Event.ENTER_FRAME,startDraw);
				this.blackPin.removeEventListener(Event.ENTER_FRAME,startDraw);
				e.target.parent.checkBoundArea();
			}
		}
		
		function stopAll(e:MouseEvent):void{
			var obj:Object;
			var i:int;
			
			if(this.isDrag){
				this.volt.stopDrag();
				this.isDrag=false;
				if(this.parent!=null){
					this.checkBoundArea();
				}
			}
			if(this.isRedDrag){
				redCollisionList.dispose();
				redCollisionList.swapTarget(this.redPin.pinTop);
				if(redTarget!=null){
					redCollisionList.addItem(redTarget);
				}
				this.redPin.stopDrag();
				this.isRedDrag=false;
				this.redPin.dispatchEvent(new Event(Event.ENTER_FRAME));
				this.redPin.removeEventListener(Event.ENTER_FRAME,startDraw);
				this.redPin.removeEventListener(Event.ENTER_FRAME,checkForCollision);
			}
			if(this.isBlackDrag){
				blackCollisionList.dispose();
				blackCollisionList.swapTarget(this.blackPin.pinTop);
				if(blackTarget!=null){
					blackCollisionList.addItem(blackTarget);
				}
				this.blackPin.stopDrag();
				this.isBlackDrag=false;
				this.blackPin.dispatchEvent(new Event(Event.ENTER_FRAME));
				this.blackPin.removeEventListener(Event.ENTER_FRAME,startDraw);
				this.blackPin.removeEventListener(Event.ENTER_FRAME,checkForCollision);
			}
		}
		
		function setSelection(stat:Boolean):void{
			
			if(stat==true){
				if(StageBuilder.selectedJn!=null){
					StageBuilder.selectedJn.filters=null;
					StageBuilder.selectedJn=null;
				}
				if(StageBuilder.selectedObj)
				StageBuilder.selectedObj.filters=null;
				this.gf=new GlowFilter(0Xff9932,0.3,11,11,3,BitmapFilterQuality.LOW,false,false);//0X660033//0XFFFF99
				this.filters=[this.gf];
				StageBuilder.selectedObj=this;
			}
			else
				this.filters=null;
		}
		
		function localToLocal(fr:MovieClip, to:MovieClip,pt:Point):Point {
			return to.globalToLocal(fr.localToGlobal(pt));
		}
		
		function setVisible(flag:Boolean):void{
			this.volt.redPinEnd.visible=flag;
			this.volt.blackPinEnd.visible=flag;
			this.redPin.visible=flag;
			this.blackPin.visible=flag;
			this.redWire.visible=flag;
			this.blackWire.visible=flag;
		}
		
		public function setupVoltmeter(){
			var pt:Point=this.localToLocal(this.parent,this.volt.parent,new Point(635,308));
			this.volt.posX=pt.x;
			this.volt.posY=pt.y;
			this.volt.currText.text="-----";
			this.volt.prevX=pt.x;
			this.volt.prevY=pt.y;
			this.volt.x=this.volt.posX;
			this.volt.y=this.volt.posY;
		}
		
		function setupPin(){
			pt=this.parent.localToGlobal(new Point(this.volt.x,this.volt.y));
			this.redPin.x=pt.x+180;
			this.redPin.y=pt.y+130;
			this.blackPin.x=pt.x+220;
			this.blackPin.y=pt.y+130;
			pt=this.localToLocal(this.volt,this,new Point(this.volt.redPinEnd.x,this.volt.redPinEnd.y));
			this.drawLine(pt.x,pt.y,this.redPin.x,this.redPin.y,0XDD0000,this.redWire);
			pt=this.localToLocal(this.volt,this,new Point(this.volt.blackPinEnd.x,this.volt.blackPinEnd.y));
			this.drawLine(pt.x,pt.y,this.blackPin.x,this.blackPin.y,0XFFFFFF,this.blackWire);
		}
		
		function movePin(e:MouseEvent){
			e.target.parent.parent.setChildIndex(e.target.parent,e.target.parent.parent.numChildren-1);
			e.target.parent.setChildIndex(e.target,e.target.parent.numChildren-1);
			e.target.addEventListener(Event.ENTER_FRAME,startDraw);
			e.target.addEventListener(MouseEvent.MOUSE_UP,stopAll);
			e.target.startDrag();
			if(e.target is RedPin){
				e.target.parent.isRedDrag=true;
			
				for(var i:int=0;i<Circuit.branches.length;i++){
					if(Circuit.branches[i].insideArea){
						redCollisionList.addItem(Circuit.branches[i].startJunction);
						redCollisionList.addItem(Circuit.branches[i].endJunction);
					}				
				}			
			}
			else if(e.target is BlackPin){
				e.target.parent.isBlackDrag=true;
				for(var j:int=0;j<Circuit.branches.length;j++){
					if(Circuit.branches[j].insideArea){
						blackCollisionList.addItem(Circuit.branches[j].startJunction);
						blackCollisionList.addItem(Circuit.branches[j].endJunction);
					}				
				}			
			}
			e.target.addEventListener(Event.ENTER_FRAME,checkForCollision);
		}
		
		function stopPin(e:MouseEvent){
			e.target.stopDrag();
			if(e.target is RedPin){
				e.target.parent.isRedDrag=false;
				redCollisionList.dispose();
				redCollisionList.swapTarget(e.target.pinTop);
				if(redTarget!=null){
					redCollisionList.addItem(redTarget);
				}
			}
			else if(e.target is BlackPin){
				e.target.parent.isBlackDrag=false;
				blackCollisionList.dispose();
				blackCollisionList.swapTarget(e.target.pinTop);
				if(blackTarget!=null){
					blackCollisionList.addItem(blackTarget);
				}
			}
			if(blackTarget==null || redTarget==null)
				e.target.removeEventListener(Event.ENTER_FRAME,checkForCollision);
				
			e.target.dispatchEvent(new Event(Event.ENTER_FRAME));
			e.target.removeEventListener(Event.ENTER_FRAME,startDraw);
		}
		
		function checkForCollision(e:Event){
			updateVoltageReading()
		}
		
		public function updateVoltageReading(){
			var VOLT=0; 
			var redCollisions:Array = redCollisionList.checkCollisions();	
			if(redCollisions.length){
				redTarget=redCollisions[0].object2;
			}
			else{
				redTarget=null;
			}
			var blackCollisions:Array = blackCollisionList.checkCollisions();		
			if(blackCollisions.length){
				blackTarget=blackCollisions[0].object2;
			}
			else{
				blackTarget=null;
			}
			if(redTarget!=null || blackTarget!=null){
				this.isInContact=true;
			}
			else{
				this.isInContact=false;
			}	
			if((redTarget==null)||(blackTarget==null)){
				//trace("if((redTarget==null)||(blackTarget==null)){")
				this.volt.currText.text="---";
				return;
			}	else{
				this.volt.currText.text="---";
			}
			if((redTarget is Junction)&&(blackTarget is Junction)){
				//trace("if((redTarget is Junction)&&(blackTarget is Junction)){")
				//trace(redTarget.ids,blackTarget.ids)
				var redNode:Node=Circuit.getNode(redTarget.ids,1);
				var blackNode:Node=Circuit.getNode(blackTarget.ids,1);
				voltageReading=Number(redNode.voltage)-Number(blackNode.voltage);
				//trace('voltageReading '+voltageReading)
				if(!isNaN(voltageReading)){
					
					this.volt.currText.text=Utilities.roundDecimal(voltageReading,2).toString()+" V";
					VOLT=voltageReading;
				}
				else{
					
					if(redTarget.parent.type=="battery" && blackTarget.parent.type=="battery"){
						this.volt.currText.text=redTarget.parent.innerComponent.voltage+" V" ;
						VOLT=Number(redTarget.parent.innerComponent.voltage);
					}
					else{
					
						this.volt.currText.text="-----";
					}
				}				
			}
			
			if(VOLT<0){
				VOLT = -1 * VOLT;
			}
			/*if(this.volt.currText.text=="-----"){
				trace("-----")
			} else{
				trace(VOLT)
			}*/
		}
		
		function startDraw(e:Event){
			
			var right:Point=e.target.parent.localToGlobal(new Point(e.target.x+e.target.width/2,e.target.y));
			var left:Point=e.target.parent.localToGlobal(new Point(e.target.x-e.target.width/2,e.target.y));
			var down:Point=e.target.parent.localToGlobal(new Point(e.target.x,e.target.y));
			var up:Point=e.target.parent.localToGlobal(new Point(e.target.x,e.target.y-e.target.height));
			
			var boundRight:Number=this.parent.boundArea.x+this.parent.boundArea.width/2;
			var boundLeft:Number=this.parent.boundArea.x-this.parent.boundArea.width/2;
			var boundUp:Number=this.parent.boundArea.y-this.parent.boundArea.height/2;
			var boundDown:Number=this.parent.boundArea.y+this.parent.boundArea.height/2;
			var pt:Point;
			
			//right
			if(right.x>boundRight){
				pt=e.target.parent.globalToLocal(new Point(this.parent.boundArea.x+this.parent.boundArea.width/2,0));
				e.target.x=pt.x;
			}
			//left
			else if(left.x<boundLeft){
				pt=e.target.parent.globalToLocal(new Point(this.parent.boundArea.x-this.parent.boundArea.width/2,0));
				e.target.x=pt.x;
			}
			//up
			else if(up.y<boundUp){
				pt=e.target.parent.globalToLocal(new Point(0,this.parent.boundArea.y-this.parent.boundArea.height/2));
				e.target.y=pt.y+e.target.height;
			}
			//down
			else if(up.y>boundDown){
				pt=e.target.parent.globalToLocal(new Point(0,this.parent.boundArea.y+this.parent.boundArea.height/2));
				e.target.y=pt.y+e.target.height;
			}
			
			if(e.target.name=="Red Pin"){
				pt=this.localToLocal(this.volt,this,new Point(this.volt.redPinEnd.x,this.volt.redPinEnd.y));
				this.drawLine(pt.x,pt.y,this.redPin.x,this.redPin.y,0XDD0000,this.redWire);
			}else if(e.target.name=="Black Pin"){
				pt=this.localToLocal(this.volt,this,new Point(this.volt.blackPinEnd.x,this.volt.blackPinEnd.y));
				this.drawLine(pt.x,pt.y,this.blackPin.x,this.blackPin.y,0XFFFFFF,this.blackWire);
			}
		}
		
		function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number,color:uint,wire:MovieClip):void{
			
			var posx:Number;
			var posy:Number;
			var anchor1:Point=new Point(xstart,ystart);
			var anchor2:Point=new Point(xend,yend);
			var control1:Point=new Point(xstart+100,ystart+50);
			var control2:Point;
			
			if(xstart>xend){
				control2=new Point(xend+100,yend+200);
			}else{
				control2=new Point(xend-100,yend+200);
			}			
			
			wire.graphics.clear();
			wire.graphics.lineStyle(15,color,1,true,"normal","CapsStyle.ROUND","JointStyle.ROUND",3);
			wire.graphics.moveTo(anchor1.x,anchor1.y);
			
			for (var u:Number = 0; u <= 1; u += 1/20) {
 
  				posx = Math.pow(u,3)*(anchor2.x+3*(control1.x-control2.x)-anchor1.x)
          				 +3*Math.pow(u,2)*(anchor1.x-2*control1.x+control2.x)
          				 +3*u*(control1.x-anchor1.x)+anchor1.x;
 
 				 posy = Math.pow(u,3)*(anchor2.y+3*(control1.y-control2.y)-anchor1.y)
           				+3*Math.pow(u,2)*(anchor1.y-2*control1.y+control2.y)
           				+3*u*(control1.y-anchor1.y)+anchor1.y;
 			
 				 wire.graphics.lineTo(posx,posy);
 
			}
 
			//Let the curve end on the second anchorPoint
			 
			wire.graphics.lineTo(anchor2.x,anchor2.y);
		}
		
		public function setPos():void{
			this.volt.x=this.volt.prevX;
			this.volt.y=this.volt.prevY;
		}
		
		function checkBoundArea():Boolean{
			
			var boundRight:Number=this.parent.boundArea.x+this.parent.boundArea.width/2;
			var boundLeft:Number=this.parent.boundArea.x-this.parent.boundArea.width/2;
			var boundUp:Number=this.parent.boundArea.y-this.parent.boundArea.height/2;
			var boundDown:Number=this.parent.boundArea.y+this.parent.boundArea.height/2;
			var right:Point=this.localToLocal(this.volt.parent,this.parent,new Point(this.volt.x+this.volt.width/2,0));
			var left:Point=this.localToLocal(this.volt.parent,this.parent,new Point(this.volt.x-this.volt.width/2,0));
			var up:Point=this.localToLocal(this.volt.parent,this.parent,new Point(0,this.volt.y-this.volt.height/2));
			var down:Point=this.localToLocal(this.volt.parent,this.parent,new Point(0,this.volt.y+this.volt.height/2));
			
			if(right.x<boundRight && left.x>boundLeft && up.y>boundUp && down.y<boundDown){
				this.volt.insideArea=true;
				this.setVisible(true);
			}	
			
			
			if(this.volt.insideArea){
				this.volt.scaleX=.78;
				this.volt.scaleY=.78;
				if(right.x>boundRight){
					this.volt.scaleX=0.55;
					this.volt.scaleY=0.55;
					this.volt.insideArea=false;
					this.setVisible(false);
					this.setupVoltmeter();
				}
				//left
				else if(left.x<boundLeft){
					this.setPos();
				}
				//up
				else if(up.y<boundUp){
					this.setPos();
				}
				//down
				else if(down.y>boundDown){
					this.setPos();
				}	
				else{
					this.volt.prevX=this.volt.x;
					this.volt.prevY=this.volt.y;
				}
			}
			else{
				this.volt.x=this.volt.posX;
				this.volt.y=this.volt.posY;
			}	
						
			if(!this.isInContact){
				this.setupPin();
			}
		}
		
	}
}