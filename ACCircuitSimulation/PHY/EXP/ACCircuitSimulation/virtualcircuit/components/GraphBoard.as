
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.components{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import virtualcircuit.logic.collision.*;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.GraphOps;
	import virtualcircuit.logic.Node;
	import virtualcircuit.components.Junction;
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.BlackPin;
	import virtualcircuit.components.RedPin;
	
	public class GraphBoard extends MovieClip{                       
		var box:GraphBox;
		var labelTop:TextField;
		var labelBottom:TextField;
		var xAxisLabel:TextField;
		var vLabel:TextField;
		var iLabel:TextField;
		var format:TextFormat;
		var blackTarget:BlackPin;
		var redTarget:RedPin;
		var iTarget:IPin;
		var	redWire:MovieClip;	
		var blackWire:MovieClip;	
		var iWire:MovieClip;	
		var	blackWireEnd:Point;
		var	redWireEnd:Point;
		var	iWireEnd:Point;
		var vGraph:Graph; 
		var iGraph:Graph; 
		var graphX:Number;
		var graphY:Number;
		var graphWidth:Number;
		var plus:Plus;
		var minus:Minus;
		var selectedObj:TextField;
		var currentPin:TextField;
		var timer:Timer;
		var blackObj:Object; //DropTarget object of the black pin
		var redObj:Object; //DropTarget object of the red pin
		var iObj:Object; //DropTarget object of the currentTarget pin
		var redCollisionList:CollisionList;//Its is a array with the first element being the target and the 			 											rest being the elements against which hit should be preformed
		var blackCollisionList:CollisionList;//Its is a array with the first element being the target and the 			 											rest being the elements against which hit should be preformed
		var iCollisionList:CollisionList;//Its is a array with the first element being the target and the 			 											rest being the elements against which hit should be preformed
		var gOps:GraphOps; //Object of GraphOps to perform graph operations
		
		public function GraphBoard(wd:Number,ht:Number){
			this.box = new GraphBox();
			this.box.width = wd-50;
			this.box.height = ht-40;
			this.box.x = 45;
			this.box.y = 10;
			addChild(this.box);
			
			this.labelTop = new TextField();
			this.labelTop.text = "10";
			this.labelTop.scaleX=0.75;
			this.labelTop.scaleY=0.75;
			this.labelTop.x = this.box.x-15;
			this.labelTop.y = this.box.y-5;
			
			this.labelBottom = new TextField();
			this.labelBottom.text="-10";
			this.labelBottom.scaleX=0.75;
			this.labelBottom.scaleY=0.75;
			this.labelBottom.x = this.box.x-15;
			this.labelBottom.y = this.box.y+this.box.height-5;
			
			var timesNew = new TimesNew();
			format = new TextFormat();
			format.font = timesNew.fontName;
			format.size = 11;
			
			this.xAxisLabel = new TextField();
			this.xAxisLabel.defaultTextFormat = format;
			this.xAxisLabel.embedFonts = true;
			this.xAxisLabel.text = "Time";
			this.xAxisLabel.scaleX=0.8;
			this.xAxisLabel.scaleY=0.8;
			this.xAxisLabel.x = this.box.x+this.box.width/2-5;
			this.xAxisLabel.y = this.box.y+this.box.height;
			addChild(this.xAxisLabel);
			
			this.vLabel = new TextField();
			this.vLabel.selectable=false;
			this.vLabel.defaultTextFormat = format;
			this.vLabel.embedFonts = true;
			this.vLabel.rotation = -90;
			this.vLabel.text = "Voltage";
			this.vLabel.width=50;
			this.vLabel.height=15;
			this.vLabel.scaleX=0.75;
			this.vLabel.scaleY=0.75;
			this.vLabel.x = this.box.x-20;
			this.vLabel.y = this.box.y+this.box.height-10;
			addChild(this.vLabel);
			this.vLabel.addEventListener(MouseEvent.MOUSE_DOWN,setSelectedObj);
			
			this.iLabel = new TextField();
			this.iLabel.selectable=false;
			this.iLabel.defaultTextFormat = format;
			this.iLabel.embedFonts=true;
			this.iLabel.rotation=-90;
			this.iLabel.text="Current";
			this.iLabel.width=50;
			this.iLabel.height=15;
			this.iLabel.scaleX=0.75;
			this.iLabel.scaleY=0.75;
			this.iLabel.x=this.box.x-30;
			this.iLabel.y=this.box.y+this.box.height-10;
			addChild(this.iLabel);
			this.iLabel.addEventListener(MouseEvent.MOUSE_DOWN,setSelectedObj);
			
			this.graphics.lineStyle(1,0X000000);
			this.graphics.beginFill(0X8BC0FF,1);
			this.graphics.drawRect(0,0,wd,ht);
			this.graphics.endFill();
			this.buttonMode=true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,drag);
			this.addEventListener(MouseEvent.MOUSE_UP,endDrag);
						
			this.blackTarget=new BlackPin();
			this.blackTarget.scaleX=0.2;
			this.blackTarget.scaleY=0.2;
			this.blackTarget.x= wd+40;
			this.blackTarget.y= ht/2-30;
			this.blackTarget.buttonMode=true;
			this.blackTarget.addEventListener(MouseEvent.MOUSE_DOWN,moveTarget);
			this.blackTarget.addEventListener(MouseEvent.MOUSE_UP,stopTarget);
			this.blackTarget.addEventListener(MouseEvent.MOUSE_OVER,showLabel);
			this.blackTarget.mouseChildren=false;
			addChild(blackTarget);
			
			this.redTarget=new RedPin();
			this.redTarget.scaleX=0.2;
			this.redTarget.scaleY=0.2;
			this.redTarget.x= wd+30;
			this.redTarget.y= ht/2-30;
			this.redTarget.buttonMode=true;
			this.redTarget.addEventListener(MouseEvent.MOUSE_DOWN,moveTarget);
			this.redTarget.addEventListener(MouseEvent.MOUSE_UP,stopTarget);
			this.redTarget.addEventListener(MouseEvent.MOUSE_OVER,showLabel);
			this.redTarget.mouseChildren=false;
			addChild(redTarget);
			
			this.iTarget=new IPin();
			this.iTarget.scaleX=0.2;
			this.iTarget.scaleY=0.2;
			this.iTarget.x=wd+40;
			this.iTarget.y=ht/2+30;
			this.iTarget.buttonMode=true;
			this.iTarget.addEventListener(MouseEvent.MOUSE_DOWN,moveTarget);
			this.iTarget.addEventListener(MouseEvent.MOUSE_UP,stopTarget);
			this.iTarget.addEventListener(MouseEvent.MOUSE_OVER,showLabel);
			this.iTarget.mouseChildren=false;
			addChild(iTarget);
						
			this.redWire=new MovieClip();
			this.blackWire=new MovieClip();
			this.iWire=new MovieClip();
			var gf:GlowFilter;
			gf=new GlowFilter(0X660033,1,2,5,3,BitmapFilterQuality.LOW,true,false);//0X660033
			this.redWire.filters=[gf];
			gf=new GlowFilter(0X000000,1,5,8,3,BitmapFilterQuality.LOW,true,false);//0X660033
			this.blackWire.filters=[gf];
			gf=new GlowFilter(0X000000,1,5,8,3,BitmapFilterQuality.LOW,true,false);//0X660033
			this.iWire.filters=[gf];
			this.blackWireEnd = new Point(wd,this.blackTarget.y);
			this.redWireEnd = new Point(wd,this.redTarget.y);
			this.iWireEnd = new Point(wd,this.iTarget.y);
			addChild(redWire);
			addChild(blackWire);
			addChild(iWire);
			
			this.drawLine(redWireEnd.x,redWireEnd.y,this.redTarget.x,this.redTarget.y,0XDD0000,this.redWire);
			this.drawLine(blackWireEnd.x,blackWireEnd.y,this.blackTarget.x,this.blackTarget.y,0X000000,this.blackWire);
			this.drawLine(iWireEnd.x,iWireEnd.y,this.iTarget.x,this.iTarget.y,0X0000FF,this.iWire);
			
			this.graphX=this.box.x;
			this.graphY=this.box.y+this.box.height/2;	
			this.graphWidth=this.box.width;
			
			this.vGraph=new Graph(this.graphX,this.graphY,this.graphX+this.graphWidth,this.box.height,0XFF0000,2);
			addChild(vGraph);
			this.setVLabelColor(0XFF0000);

			this.iGraph=new Graph(this.graphX,this.graphY,this.graphX+this.graphWidth,this.box.height,0X0000FF,2);
			addChild(iGraph);
			this.setILabelColor(0X0000FF);

			this.gOps=new GraphOps();
			this.redCollisionList=new CollisionList(this.redTarget.pinTop);
			this.blackCollisionList=new CollisionList(this.blackTarget.pinTop);
			this.iCollisionList=new CollisionList(this.iTarget.pinTop);
			
			this.setChildIndex(this.redTarget,this.numChildren-1);
			this.setChildIndex(this.blackTarget,this.numChildren-1);
			
			this.plus=new Plus();
			this.plus.scaleX=.55;
			this.plus.scaleY=.55;
			this.plus.x=this.labelTop.x-5;
			this.plus.y=this.labelTop.y+5;
			addChild(this.plus);
			this.plus.addEventListener(MouseEvent.MOUSE_DOWN,scaleGraph);
			
			this.minus=new Minus();
			this.minus.scaleX=.55;
			this.minus.scaleY=.55;
			this.minus.x=this.plus.x-15;
			this.minus.y=this.plus.y;
			addChild(this.minus);
			this.minus.addEventListener(MouseEvent.MOUSE_DOWN,scaleGraph);
			
			this.currentPin=new TextField();
			this.currentPin.defaultTextFormat=format;
			this.currentPin.selectable=false;
			this.currentPin.width=80;
			this.currentPin.height=20;
			addChild(this.currentPin);
			
			setSelection(this.vLabel,true);
			this.setMouseEnabled(false);
			this.timer=new Timer(1000);
		}
		
		//sets the mouseEnabled
		function setMouseEnabled(flag:Boolean){
			box.mouseEnabled=flag;
			labelTop.mouseEnabled=flag;
			labelBottom.mouseEnabled=flag;
			xAxisLabel.mouseEnabled=flag;
			redWire.mouseEnabled=flag;
			blackWire.mouseEnabled=flag;
			iWire.mouseEnabled=flag;
			currentPin.mouseEnabled=flag;
		}
		function setSelectedObj(e:MouseEvent){
			setSelection(e.target,true);
		}
		//sets the mouseEnabled
		function setSelection(lab:TextField,flag:Boolean){
			if(this.selectedObj!=null)
				this.selectedObj.filters=null;
			var gf:GlowFilter=new GlowFilter(0Xff9932,1,11,11,5,BitmapFilterQuality.LOW,false,false);
			this.selectedObj=lab;
			this.selectedObj.filters=[gf];
		}
		
		public function setVLabelColor(color:uint){
			this.format.color=color;
			this.vLabel.setTextFormat(format);
		}
		public function setILabelColor(color:uint){
			this.format.color=color;
			this.iLabel.setTextFormat(format);
		}
		//Start drag and stop drag for graph
		function drag(e:MouseEvent){
			if(e.target is GraphBoard)
				e.target.startDrag();
		}
		function endDrag(e:MouseEvent){
			if(e.target is GraphBoard)
				e.target.stopDrag();
		}
		//Start drag and stop drag for the targets
		function moveTarget(e:MouseEvent){
			e.target.parent.parent.setChildIndex(e.target.parent,e.target.parent.parent.numChildren-1);
			e.target.parent.setChildIndex(e.target,e.target.parent.numChildren-1);
			e.target.startDrag();
			e.target.addEventListener(Event.ENTER_FRAME,startDraw);			
			if(e.target is RedPin){
				for(var i:int=0;i<Circuit.branches.length;i++){
					if(Circuit.branches[i].insideArea){
						redCollisionList.addItem(Circuit.branches[i].startJunction);
						redCollisionList.addItem(Circuit.branches[i].endJunction);
					}				
				}			
				e.target.addEventListener(Event.ENTER_FRAME,checkForCollision);
			}
			else if(e.target is BlackPin){
				for(var j:int=0;j<Circuit.branches.length;j++){
					if(Circuit.branches[j].insideArea){
						blackCollisionList.addItem(Circuit.branches[j].startJunction);
						blackCollisionList.addItem(Circuit.branches[j].endJunction);
					}				
				}			
				e.target.addEventListener(Event.ENTER_FRAME,checkForCollision);
			}
			else if(e.target is IPin){
				for(var k:int=0;k<Circuit.branches.length;k++){
					if(Circuit.branches[k].insideArea){
						iCollisionList.addItem(Circuit.branches[k]);
					}				
				}			
				e.target.addEventListener(Event.ENTER_FRAME,checkForCollision);
			}
			
		}
		function stopTarget(e:MouseEvent){
			e.target.stopDrag();
			e.target.dispatchEvent(new Event(Event.ENTER_FRAME));
			e.target.removeEventListener(Event.ENTER_FRAME,startDraw);			
			
			if(e.target is RedPin){
				redCollisionList.dispose();
				redCollisionList.swapTarget(e.target.pinTop);
				if(redObj!=null){
					redCollisionList.addItem(redObj);
				}
			}
			else if(e.target is BlackPin){
				blackCollisionList.dispose();
				blackCollisionList.swapTarget(e.target.pinTop);
				if(blackObj!=null){
					blackCollisionList.addItem(blackObj);
				}
			}
			else if(e.target is IPin){
				iCollisionList.dispose();
				iCollisionList.swapTarget(e.target.pinTop);
				if(iObj!=null){
					iCollisionList.addItem(iObj);
				}
				else
					e.target.removeEventListener(Event.ENTER_FRAME,checkForCollision);		
			}
			if(!(e.target is ITarget)){
				if(blackObj==null || redObj==null){
					e.target.removeEventListener(Event.ENTER_FRAME,checkForCollision);	
				}
			}
		}
		
		function checkForCollision(e:Event){
			var redCollisions:Array = redCollisionList.checkCollisions();	
			if(redCollisions.length){
				if(redCollisions[0].object2 is Junction)
					redObj=redCollisions[0].object2;
				else
					redObj=redCollisions[0].object1;
			}
			else{
				redObj=null;
			}
			var blackCollisions:Array = blackCollisionList.checkCollisions();		
			if(blackCollisions.length){
				if(blackCollisions[0].object2 is Junction)
					blackObj=blackCollisions[0].object2;
				else
					blackObj=blackCollisions[0].object1;
			}
			else{
				blackObj=null;
			}
			var iCollisions:Array = iCollisionList.checkCollisions();	
			if(iCollisions.length){
				if(iCollisions[0].object2 is Branch)
					iObj=iCollisions[0].object2;
				else
					iObj=iCollisions[0].object1;
			}
			else{
				iObj=null;
			}
			if(redObj!=null && blackObj!=null){
				if(redObj.parent.subCircuitIndex==blackObj.parent.subCircuitIndex){
					var redNode:Node=Circuit.getNode(redObj.ids,1);
					var blackNode:Node=Circuit.getNode(blackObj.ids,1);
					if((redNode!=null && blackNode!=null) && redNode.subCircuitIndex!=-1){
						var voltageReading:Number=gOps.findVoltage(redNode,blackNode);
						vGraph.drawArc(voltageReading);
					}
				}
			}
			else
				vGraph.drawArc(0);
			
			if(iObj!=null){
				if(iObj.subCircuitIndex!=-1 && iObj.type!="ac power"){
					var iReading:Number=0;
					if(iObj.type=="capacitor"){
						iReading=iObj.phaseCurrent;
					}else if(iObj.type=="inductor"){
						iReading=-(iObj.phaseCurrent);
					}
					else{
						iReading=-(iObj.current.getRealPart());
					}
					iGraph.drawArc(iReading);
				}
			}
			else
				iGraph.drawArc(0);			
		}
		//Draws the wire between the pinEnd and pin using moveTo and lineTo
		function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number,color:uint,wire:MovieClip):void{
			
			var posx:Number;
			var posy:Number;
			var anchor1:Point=new Point(xstart,ystart);
			var anchor2:Point=new Point(xend,yend);
			var control1:Point=new Point(xstart+75,ystart+40);
			var control2:Point;
			
			if(xstart>xend){
				control2=new Point(xend+75,yend+125);
			}else{
				control2=new Point(xend-75,yend+125);
			}			
			
			wire.graphics.clear();
			wire.graphics.lineStyle(3,color,1,true,"normal","CapsStyle.ROUND","JointStyle.ROUND",3);
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
		
		function startDraw(e:Event){
			if(e.target is RedPin){
				this.drawLine(redWireEnd.x,redWireEnd.y,e.target.x,e.target.y,0XDD0000,this.redWire);
			}else if(e.target is BlackPin){
				this.drawLine(blackWireEnd.x,blackWireEnd.y,e.target.x,e.target.y,0X000000,this.blackWire);
			}
			else if(e.target is IPin){
				this.drawLine(iWireEnd.x,iWireEnd.y,e.target.x,e.target.y,0X0000FF,this.iWire);
			}
		}
		
		function scaleGraph(e:MouseEvent){
			if(e.target is Plus){
				if(this.selectedObj.text=="Voltage")
					vGraph.scaleAt(6/5);
				else if(this.selectedObj.text=="Current")
					iGraph.scaleAt(6/5);
			}else if(e.target is Minus){
				if(this.selectedObj.text=="Voltage")
					vGraph.scaleAt(5/6);
				else if(this.selectedObj.text=="Current")
					iGraph.scaleAt(5/6);
			}
		}
		
		public function removeAllEnterFrame(){
			if(this.redTarget.hasEventListener(Event.ENTER_FRAME))
				this.redTarget.removeEventListener(Event.ENTER_FRAME,checkForCollision);
			if(this.blackTarget.hasEventListener(Event.ENTER_FRAME))
				this.blackTarget.removeEventListener(Event.ENTER_FRAME,checkForCollision);
			if(this.iTarget.hasEventListener(Event.ENTER_FRAME))
				this.iTarget.removeEventListener(Event.ENTER_FRAME,checkForCollision);
		}
		function showLabel(e:MouseEvent):void{
			if(e.target is BlackPin){
				this.currentPin.text="Volt Negative";
				this.currentPin.x=e.target.x-30;
				this.currentPin.y=e.target.y-e.target.height-15;
			}
			if(e.target is RedPin){
				this.currentPin.text="Volt Positive";
				this.currentPin.x=e.target.x-30;
				this.currentPin.y=e.target.y-e.target.height-15;
			}
			if(e.target is IPin){
				this.currentPin.text="Current";
				this.currentPin.x=e.target.x;
				this.currentPin.y=e.target.y-e.target.height/2;
			}
			this.currentPin.parent.setChildIndex(this.currentPin,this.currentPin.parent.numChildren-1);
			this.currentPin.visible=true;
			timer.addEventListener(TimerEvent.TIMER,removeLabel);
			timer.start();
		}
		function removeLabel(e:TimerEvent):void{
			this.currentPin.visible=false;
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,removeLabel);
		}
		
	}
}