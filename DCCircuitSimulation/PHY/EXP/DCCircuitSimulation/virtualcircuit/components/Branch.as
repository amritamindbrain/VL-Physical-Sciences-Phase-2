
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.userinterface.StageBuilder;
	
	public class Branch extends DynamicMovie{
		
		// Constants:
		
		// Public Properties:
		public var current:Number;
		public var voltageDrop:Number;
		public var startJunction:Junction;
		public var endJunction:Junction;
		public var type:String;
		public var innerComponent:CircuitComponent;
		public var innerComponentRef:Object;
		public var insideArea:Boolean;
		public var subCircuitIndex:int;
		var compLabel:TextField;
		var startJnLabel:TextField;
		var endJnLabel:TextField;
		var val:TextField;
		// Private Properties:
		public var ids:String;
		var prevX:Number;
		var prevY:Number;
		var gf:GlowFilter;

		public var visited:Boolean;
		// Initialization:
		
		public function Branch(type:String) { 
			this.alpha=1;
			this.type=type;
			this.current="10";
			this.startJunction=new Junction();
			this.endJunction=new Junction();
			this.innerComponentRef=getInnerComponent(this.type);
			this.innerComponent=CircuitComponent(this.innerComponentRef);
			this.insideArea=false;
			this.visited=false;
			
			this.gf=new GlowFilter(0Xff9932,1,11,11,3,BitmapFilterQuality.LOW,false,false);//0X660033//0XFFFF99
		
			//NOTE:- this is with the assumption that life like is the first view by default
			
			this.startJunction.setPrev(0,0);
			this.startJunction.setPos();
			if(this.type=="wire"){
				this.innerComponentRef.drawLine(this.startJunction.x,this.startJunction.y,this.startJunction.x+100,this.startJunction.y);
				this.endJunction.setPrev(this.innerComponent.width-this.endJunction.width/2,this.startJunction.y);
				this.endJunction.setPos();
			}
			else{
				this.innerComponent.x=this.startJunction.x+this.innerComponent.width/2;
				this.innerComponent.y=this.startJunction.y;
				this.endJunction.setPrev(this.innerComponent.width,this.startJunction.y);
				this.endJunction.setPos();
			}
			
			if(Circuit.isSchematic()){
				this.innerComponentRef.schematicComponent.visible=true;
				this.innerComponentRef.realComponent.visible=false;
			}
			
			else{
				this.innerComponentRef.schematicComponent.visible=false;
				this.innerComponentRef.realComponent.visible=true;
			}
			this.endJunction.opp=true;
			this.prevX=0;
			this.prevY=0;
			
			this.current=0;
			this.voltageDrop=0;
			this.x=100;
			this.y=100;
			
			this.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,startRotate);
			this.startJunction.addEventListener(MouseEvent.MOUSE_UP,stopRotate);
			this.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,startRotate);
			this.endJunction.addEventListener(MouseEvent.MOUSE_UP,stopRotate);
			this.addChild(this.innerComponent);
			this.addChild(this.endJunction);
			this.addChild(this.startJunction);
			this.setChildIndex(this.startJunction,this.numChildren-1);
			this.setChildIndex(this.endJunction,this.numChildren-2);
			this.setChildIndex(this.innerComponent,0);
			this.setRegistration(this.width/2,this.height/2);
			
			var timesNew=new TimesNew();
			var format:TextFormat = new TextFormat();
			format.font=timesNew.fontName;
			format.size = 11;
			format.color = 0X666666;
			
			this.compLabel= new TextField();
			this.startJnLabel= new TextField();
			this.endJnLabel= new TextField();
			this.val= new TextField();
			
			this.compLabel.width= 30;
			this.startJnLabel.width= 30;
			this.endJnLabel.width= 30;
			this.val.width= 65;
			this.compLabel.height= 30;
			this.startJnLabel.height= 30;
			this.endJnLabel.height= 30;
			this.val.height= 80;
			
			this.compLabel.defaultTextFormat = format;
			this.startJnLabel.defaultTextFormat = format;
			this.endJnLabel.defaultTextFormat = format;
			format.size = 13;
			this.val.defaultTextFormat = format;
			
			this.compLabel.embedFonts= true;
			this.startJnLabel.embedFonts= true;
			this.endJnLabel.embedFonts= true;
			this.val.embedFonts= true;
			
			this.compLabel.mouseEnabled= false;
			this.startJnLabel.mouseEnabled=false;
			this.endJnLabel.mouseEnabled= false;
			this.val.mouseEnabled= false;
					
			this.compLabel.x= this.innerComponent.x-10;
			this.startJnLabel.x=this.startJunction.x-10;
			this.endJnLabel.x= this.endJunction.x;
						
			this.compLabel.y= this.innerComponent.y+20;
			this.startJnLabel.y=this.startJunction.y-this.startJunction.height/2-20;
			this.endJnLabel.y= this.endJunction.y-this.endJunction.height/2-20;
			
			this.addChild(this.compLabel);
			this.addChild(this.startJnLabel);
			this.addChild(this.endJnLabel);
			if(type!="ammeter")
				this.addChild(this.val);
			this.val.visible=false;
			if(!Circuit.isSchematic())
				this.setLabelVisible(false);
			
			this.toggleView();
		}
		
		// Public Methods:
		public function setCompLabel(compL:String):void{
			this.compLabel.text= compL;
		}
		public function setStartJnLabel(jnLabel:String):void{
			this.startJnLabel.text=jnLabel;
		}
		public function setEndJnLabel(jnLabel:String):void{
			this.endJnLabel.text= jnLabel;
		}
		public function setLabelVisible(flag:Boolean):void{
			this.compLabel.visible= flag;
			this.startJnLabel.visible=flag;
			this.endJnLabel.visible= flag;
		}
		
		public function setVal(flag:Boolean):void{
			
			if(this.type=="resistor"){
				this.val.text= this.innerComponent.resistance+" Ohms";
			}
			else if(this.type=="bulb"){
				this.val.text= this.innerComponent.powerRating+" W\n"+this.innerComponent.voltageRating+" V";
			}
			else if(this.type=="battery"){
				this.val.text= this.innerComponent.voltage+" V";
			}
			
			this.val.visible=flag;
		}
		
		public function getVoltageDrop():Number{
			
			return this.voltage;
		}
		
		public function getCurrent():Number{
			
			return this.current;
		}
		
		public function setVoltageDrop(newVoltageDrop:Number):void{
			
			this.voltageDrop=newVoltageDrop;
		}
		
		public function setCurrent(newCurrent):void{
			
			this.current=newCurrent;
		}
		
		public function toggleView():void{
			if(!Circuit.isSchematic()){
				setLabelVisible(false);
				if(this.type=="resistor"){
					this.val.x= this.innerComponent.x-35;
					this.val.y= this.innerComponent.y-40;	
				}
				else if(this.type=="bulb"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-100;	
				}
				else if(this.type=="battery"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-40;	
				}
			}
			else{
				setLabelVisible(true);
				if(this.type=="resistor"){
					this.val.x= this.innerComponent.x-35;
					this.val.y= this.innerComponent.y-40;	
				}
				else if(this.type=="bulb"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-60;	
				}
				else if(this.type=="battery"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-50;	
				}
			}
				
			this.innerComponentRef.toggleView();
		}
		
		public function setSelection(stat:Boolean):void{
			
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
		
		
		
		// Protected Methods:
		
		private function getInnerComponent(type:String):CircuitComponent{
			
			if(type=="resistor")
			{
				return new Resistor();
			}
			
			else if(type=="battery")
			{
				return new Battery();
			}
			
			else if(type=="wire")
			{

				return new Wire();
			}
			
			else if(type=="switch")
			{
				return new Switch();
			}
			
			else if(type=="bulb")
			{
				return new Bulb();
			}
			
			else if(type=="ammeter")
			{
				return new Ammeter();
			}
			
			else
				return null;
				
			return null;
		
		}
		
		function startRotate(e:MouseEvent) {
			
			if(e.target.isSnapped!=true)
			e.target.addEventListener(Event.ENTER_FRAME,e.target.hitOnJunction )
			
			this.innerComponent.forRotation(e.target.parent.innerComponent);
	
			if(e.target.parent.type!="wire"){
				e.target.parent.parent.setChildIndex(e.target.parent,e.target.parent.parent.numChildren-1);
			}
			
			
			if(this.type!="wire"){
				if(e.target.opp==false){
					e.target.parent.setRegistration(e.target.parent.endJunction.x,e.target.parent.endJunction.y);
				}	
				else{
					e.target.parent.setRegistration(e.target.parent.startJunction.x,e.target.parent.startJunction.y);
				}
				e.target.addEventListener(Event.ENTER_FRAME,rotate);
				if(this.parent.parent!=null){
					this.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAll);
				}
				
			}
			else{
				if(e.target.opp==false){
					e.target.parent.endJunction.addEventListener(Event.ENTER_FRAME,rotateWire);
				}	
				else{
					e.target.parent.startJunction.addEventListener(Event.ENTER_FRAME,rotateWire);
				}	
				e.target.startDrag();
				//trace("Drag: "+e.target);
				if(this.parent.parent!=null){
					this.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAllWire);
				}
			}
		}
		
		public function stopRotate(e:Event) {
			
			e.target.removeEventListener(Event.ENTER_FRAME,e.target.hitOnJunction )
						
			var boundRight:Number=e.target.parent.parent.boundArea.x+e.target.parent.parent.boundArea.width/2;
			var boundLeft:Number=e.target.parent.parent.boundArea.x-e.target.parent.parent.boundArea.width/2;
			var boundUp:Number=e.target.parent.parent.boundArea.y-e.target.parent.parent.boundArea.height/2;
			var boundDown:Number=e.target.parent.parent.boundArea.x+e.target.parent.parent.boundArea.height/2;
			
			e.target.parent.setRegistration(e.target.parent.width/2,e.target.parent.height/2);
			
			//REMOVE ALL LISTENERS ADDED HERE
			
			
			if(this.type=="wire"){
				e.target.stopDrag();
				if(e.target.opp==false){
					pt=e.target.parent.localToGlobal(new Point(e.target.parent.startJunction.x,e.target.parent.startJunction.y));
					//right
					if(pt.x>boundRight){
						e.target.parent.startJunction.setPos();
					}
					//left
					else if(pt.x<boundLeft){
						e.target.parent.startJunction.setPos();
					}
					//up
					else if(pt.y<boundUp){
						e.target.parent.startJunction.setPos();
					}
					//Down
					else if(pt.y>boundDown){
						e.target.parent.startJunction.setPos();
					}
					else{
						e.target.parent.startJunction.setPrev(this.startJunction.x,this.startJunction.y);
					}					
					this.innerComponentRef.drawLine(this.startJunction.x,this.startJunction.y,this.endJunction.x,this.endJunction.y);
					e.target.parent.endJunction.removeEventListener(Event.ENTER_FRAME,rotateWire);
					
				}	
				else{
					pt=e.target.parent.localToGlobal(new Point(e.target.parent.endJunction.x,e.target.parent.endJunction.y));
					//right
					if(pt.x>boundRight){
						e.target.parent.endJunction.setPos();
					}
					//left
					else if(pt.x<boundLeft){
						e.target.parent.endJunction.setPos();
					}
					//up
					else if(pt.y<boundUp){
						e.target.parent.endJunction.setPos();
					}
					//Down
					else if(pt.y>boundDown){
						e.target.parent.endJunction.setPos();
					}
					else{
						e.target.parent.endJunction.setPrev(this.endJunction.x,this.endJunction.y);
					}
					this.innerComponentRef.drawLine(this.endJunction.x,this.endJunction.y,this.startJunction.x,this.startJunction.y);
					e.target.parent.startJunction.removeEventListener(Event.ENTER_FRAME,rotateWire);
				}
				for (i=0; i<e.target.neighbours.length; i++) {
				
					e.target.neighbours[i].jnc=e.target;
					if((e.target.parent.type!="wire")||((e.target.parent.type=="wire")&&(e.target.neighbours[i].parent.type=="wire"))){
						e.target.parent.innerComponent.moveTogether(e.target.neighbours[i])
						e.target.parent.innerComponent.updateWires(e.target.neighbours[i]);
					}
				}
			}
			else{
				e.target.removeEventListener(Event.ENTER_FRAME,rotate);
			}	
		}
		
		function rotate(e:Event) {
			var angle:Number;
			var yln:Number;
			var xln:Number;
			var mousePos:Point=e.target.parent.localToGlobal(new Point(mouseX,mouseY));
			var myDegrees:Number;
			
			//right
			if(mousePos.x>e.target.parent.parent.boundArea.x+e.target.parent.parent.boundArea.width/2){
				e.target.parent.setPos();
			}
			//left
			else if(mousePos.x<e.target.parent.parent.boundArea.x-e.target.parent.parent.boundArea.width/2){
				e.target.parent.setPos();
			}
			//up
			else if(mousePos.y<e.target.parent.parent.boundArea.y-e.target.parent.parent.boundArea.height/2){
				e.target.parent.setPos();
			}
			//down
			else if(mousePos.y>e.target.parent.parent.boundArea.y+e.target.parent.parent.boundArea.height/2){
				e.target.parent.setPos();
			}
			else{
				if(e.target.opp==false){
						yln=e.target.parent.y2-mousePos.y;
						xln=e.target.parent.x2-mousePos.x;		
				}
				else{
					yln=mousePos.y-e.target.parent.y2;
					xln=mousePos.x-e.target.parent.x2;
				}
				angle=Math.atan2(yln,xln);
				myDegrees = Math.round((angle*180/Math.PI));
				e.target.parent.rotation2=myDegrees;
				if(e.target.parent.type=="battery"){
					if((e.target.parent.rotation2>90 && e.target.parent.rotation2 <180) ||(e.target.parent.rotation2<-90 && e.target.parent.rotation2>=-180 || e.target.parent.rotation2==180 )){
						e.target.parent.innerComponent.fire.rotation=180;
						e.target.parent.innerComponent.fire.y=50;
					}
					else{
						e.target.parent.innerComponent.fire.rotation=0;
						e.target.parent.innerComponent.fire.y=-50;
					}
				}
				e.target.parent.setPrev(e.target.parent.x,e.target.parent.y);
			}
		}
		
		
		
		function rotateWire(e:Event) {
			if(e.target.opp==false){
				this.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.endJunction.x,e.target.parent.endJunction.y);				
			}
			else{
				this.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.startJunction.x,e.target.parent.startJunction.y);		
			}
		}	
		
		function stopAll(e:MouseEvent) {
				
				if(this.startJunction.hasEventListener(Event.ENTER_FRAME)){
					this.startJunction.removeEventListener(Event.ENTER_FRAME,rotate);
					this.startJunction.removeEventListener(Event.ENTER_FRAME,this.startJunction.hitOnJunction );
				}
				if(this.endJunction.hasEventListener(Event.ENTER_FRAME)){
					this.endJunction.removeEventListener(Event.ENTER_FRAME,rotate);
					this.endJunction.removeEventListener(Event.ENTER_FRAME,this.endJunction.hitOnJunction );
				}
		}
		
		function stopAllWire(e:MouseEvent) {
			
			//e.target.removeEventListener(Event.ENTER_FRAME,e.target.hitOnJunction )
			
			if(this.parent!=null){
				var boundRight:Number=this.parent.boundArea.x+this.parent.boundArea.width/2;
				var boundLeft:Number=this.parent.boundArea.x-this.parent.boundArea.width/2;
				var boundUp:Number=this.parent.boundArea.y-this.parent.boundArea.height/2;
				var boundDown:Number=this.parent.boundArea.x+this.parent.boundArea.height/2;
				
				this.setRegistration(this.width/2,this.height/2);
				if(this.startJunction.hasEventListener(Event.ENTER_FRAME)){
						pt=this.localToGlobal(new Point(this.endJunction.x,this.endJunction.y));
						//right
						if(pt.x>boundRight){
							this.endJunction.setPos();
						}
						//left
						else if(pt.x<boundLeft){
							this.endJunction.setPos();
						}
						//up
						else if(pt.y<boundUp){
							this.endJunction.setPos();
						}
						//Down
						else if(pt.y>boundDown){
							this.endJunction.setPos();
						}
						else{
							this.endJunction.setPrev(this.endJunction.x,this.endJunction.y);
						}
						this.innerComponentRef.drawLine(this.endJunction.x,this.endJunction.y,this.startJunction.x,this.startJunction.y);
						this.startJunction.removeEventListener(Event.ENTER_FRAME,rotateWire);
				}
				if(this.endJunction.hasEventListener(Event.ENTER_FRAME)){
						pt=this.localToGlobal(new Point(this.startJunction.x,this.startJunction.y));
						//right
						if(pt.x>boundRight){
							this.startJunction.setPos();
						}
						//left
						else if(pt.x<boundLeft){
							this.startJunction.setPos();
						}
						//up
						else if(pt.y<boundUp){
							this.startJunction.setPos();
						}
						//Down
						else if(pt.y>boundDown){
							this.startJunction.setPos();
						}
						else{
							this.startJunction.setPrev(this.startJunction.x,this.startJunction.y);
						}					
						this.innerComponentRef.drawLine(this.startJunction.x,this.startJunction.y,this.endJunction.x,this.endJunction.y);
						this.endJunction.removeEventListener(Event.ENTER_FRAME,rotateWire);
				}
			}
		}
		
		public function setPos():void{
			this.x=this.prevX;
			this.y=this.prevY;
		}
		
		public function setPrev(posX:Number,posY:Number):void{
			this.prevX=posX;
			this.prevY=posY;
		}
		
	}
	
}