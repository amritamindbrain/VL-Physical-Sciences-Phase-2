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
	import virtualcircuit.logic.ComplexNumber;
	import virtualcircuit.logic.Utilities;
	import virtualcircuit.userinterface.StageBuilder;
	
	public class Branch extends DynamicMovie{
		
		// Constants:
		
		// Public Properties:
		public var current:ComplexNumber;	//Current through the Branch
		public var rmsCurrent:Number;	//RMS Current through the Branch
		public var phaseCurrent:Number;	//RMS Current through the Branch
		public var voltageDrop:ComplexNumber;	//Voltage through the Branch
		public var rmsVoltage:Number;	//RMS Voltage through the Branch
		public var startJunction:Junction;	//The Start Junction of the Branch
		public var endJunction:Junction;	//The End Junction of the Branch
		public var type:String;	//Indicates the type of the Branch, ie, if the bracnh is a resistor or Bulb etc
		public var innerComponent:CircuitComponent; //Object of CircuitComponent
		public var innerComponentRef:Object;	//The Object of the Component
		public var insideArea:Boolean;//Boolean indicating whether the branch is inside the user restricted Area
		public var subCircuitIndex:int; //Indicates to which sub Circuit the branch belongs to.
		public var isVRMSReached:Boolean;	//Indicates if the rms Value of Voltage has been reached.
		public var isIRMSReached:Boolean;	//Indicates if the rms Value of Current has been reached.
		var compLabel:TextField;	//	Label for component 
		var startJnLabel:TextField;	//	Label for start junction 
		var endJnLabel:TextField;	//	Label for end junction 
		var val:TextField;		// 	Text Field to display the values of the branch
		// Private Properties:
		public var ids:String;	//Id unique for each branch 
		var prevX:Number;		//previous x position of the branch
		var prevY:Number;		//previous y position of the branch
		var gf:GlowFilter;		//GLow Filter to show the branch has been selected 

		public var visited:Boolean;
		// Initialization:
		
		//Constructor
		public function Branch(type:String) { 
			this.alpha=1;
			this.type=type;
			this.startJunction=new Junction();
			this.endJunction=new Junction();
			this.innerComponentRef=getInnerComponent(this.type);
			this.innerComponent=CircuitComponent(this.innerComponentRef);
			this.insideArea=false;
			this.visited=false;
			this.subCircuitIndex=-1;
			this.isVRMSReached=false;
			this.isIRMSReached=false;
			
			this.voltageDrop=new ComplexNumber();
			this.voltageDrop.rectangularForm(0,0);
			this.current=new ComplexNumber();
			this.current.rectangularForm(0,0);
			this.rmsVoltage=0;
			this.rmsCurrent=0;
			this.phaseCurrent=0;
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
		
		//Scale the start and end junctions and the labels 
		public function scaleJunctions(xfactor:Number,yfactor:Number,xlabel:Number=.9,ylabel:Number=.9){
			this.startJunction.scaleX=xfactor;
			this.startJunction.scaleY=yfactor;
			this.endJunction.scaleX=xfactor;
			this.endJunction.scaleY=yfactor;
			
			this.compLabel.scaleX=xlabel;
			this.startJnLabel.scaleX=xlabel;
			this.endJnLabel.scaleX=xlabel;
			this.val.scaleX=xlabel;
			
			this.compLabel.scaleY=ylabel;
			this.startJnLabel.scaleY=ylabel;
			this.endJnLabel.scaleY=ylabel;
			this.val.scaleY=ylabel;
		}
		
		//set the start and end junction positions
		public function setJnPos(startx:Number,starty:Number,endx:Number,endy:Number){
			var i:int;
			var pdt:Point;
			var newPt:Point;
			var transPt:Point;
			
			//change the position of start junction
			this.startJunction.x=startx;
			this.startJunction.y=starty;
			
			//draw the neighbuors of start Junction to the new point
			for(i=0;i<this.startJunction.neighbours.length;i++){
				pdt=new Point(this.startJunction.x,this.startJunction.y);
				newPt=this.startJunction.parent.localToGlobal(pdt);
				transPt=this.startJunction.neighbours[i].parent.globalToLocal(newPt);
				this.startJunction.neighbours[i].x=transPt.x;
				this.startJunction.neighbours[i].y=transPt.y;
				if(this.startJunction.neighbours[i].opp){
					this.startJunction.neighbours[i].parent.innerComponentRef.drawLine(this.startJunction.neighbours[i].x,this.startJunction.neighbours[i].y,this.startJunction.neighbours[i].parent.startJunction.x,this.startJunction.neighbours[i].parent.startJunction.y);		
				}
				else{
					this.startJunction.neighbours[i].parent.innerComponentRef.drawLine(this.startJunction.neighbours[i].x,this.startJunction.neighbours[i].y,this.startJunction.neighbours[i].parent.endJunction.x,this.startJunction.neighbours[i].parent.endJunction.y);					
				}
			}			
			
			//change the position of end junction
			this.endJunction.x=endx;
			this.endJunction.y=endy;
			
			//draw the neighbuors of end Junction to the new point
			for(i=0;i<this.endJunction.neighbours.length;i++){
				pdt=new Point(this.endJunction.x,this.endJunction.y);
				newPt=this.endJunction.parent.localToGlobal(pdt);
				transPt=this.endJunction.neighbours[i].parent.globalToLocal(newPt);
				this.endJunction.neighbours[i].x=transPt.x;
				this.endJunction.neighbours[i].y=transPt.y;
				if(this.endJunction.neighbours[i].opp){
					this.endJunction.neighbours[i].parent.innerComponentRef.drawLine(this.endJunction.neighbours[i].x,this.endJunction.neighbours[i].y,this.endJunction.neighbours[i].parent.startJunction.x,this.endJunction.neighbours[i].parent.startJunction.y);		
				}
				else{
					this.endJunction.neighbours[i].parent.innerComponentRef.drawLine(this.endJunction.neighbours[i].x,this.endJunction.neighbours[i].y,this.endJunction.neighbours[i].parent.endJunction.x,this.endJunction.neighbours[i].parent.endJunction.y);					
				}
			}			
		}
		
		//Scale the real and schematic components 
		public function scaleAll(xreal:Number,yreal:Number,xsc:Number,ysc:Number){
			
			this.innerComponent.realComponent.scaleX=xreal;
			this.innerComponent.realComponent.scaleY=yreal;
			this.innerComponent.schematicComponent.scaleX=xsc;
			this.innerComponent.schematicComponent.scaleY=ysc;
		}
		
		//set the component label
		public function setCompLabel(compL:String):void{
			this.compLabel.text= compL;
		}
		//set the start junction label
		public function setStartJnLabel(jnLabel:String):void{
			this.startJnLabel.text=jnLabel;
		}
		//set the end junction label
		public function setEndJnLabel(jnLabel:String):void{
			this.endJnLabel.text= jnLabel;
		}
		//set visibility of the labels
		public function setLabelVisible(flag:Boolean):void{
			this.compLabel.visible= flag;
			this.startJnLabel.visible=flag;
			this.endJnLabel.visible= flag;
		}
		
		//set the value of the TextField according to the branch
		public function setVal(flag:Boolean):void{
			
			if(this.type=="resistor"){
				this.val.text= this.innerComponent.resistance+" Ohms";
			}
			else if(this.type=="capacitor"){
				this.val.text= this.innerComponent.capacitance+" F";
			}
			else if(this.type=="inductor"){
				this.val.text= this.innerComponent.inductance+" H";
			}
			else if(this.type=="bulb"){
				this.val.text= this.innerComponent.resistance+" Ohms";
			}
			else if(this.type=="battery"){
				this.val.text= this.innerComponent.voltage+" Volts";
			}
			else if(this.type=="ac power"){
				this.val.text= this.innerComponent.rmsVoltage+" Volts\n"+this.innerComponent.frequency+" Hz";
			}
			this.val.visible=flag;
		}
		
		//Get the voltage across the branch
		public function getVoltageDrop():ComplexNumber{
			
			return this.voltage;
		}
		//Get the current across the branch
		public function getCurrent():ComplexNumber{
			
			return this.current;
		}
		//Get the RMS current across the branch
		public function getRMSCurrent():Number{
			
			return this.rmsCurrent;
		}
		//Get the RMS voltage across the branch
		public function getRMSVoltage():ComplexNumber{
			
			return this.rmsVoltage;
		}
		//reset the RMS values of the branch
		public function resetRMS(){
			this..rmsVoltage=0;
			this.rmsCurrent=0;
			this.current=new ComplexNumber();
			this.voltageDrop=new ComplexNumber();
			this.isVRMSReached=false;
			this.isIRMSReached=false;
		}
	//set the voltage Drop across the branch and update the RMS value untill the RMS value of voltage has reached
		public function setVoltageDrop(newVoltageDrop:ComplexNumber):void{
			
			this.voltageDrop=newVoltageDrop;
			var newRMS:Number=newVoltageDrop.getMagnitude()/Math.pow(2,0.5);
			if(!this.isVRMSReached){
				if(newRMS>=this.rmsVoltage){
					this.rmsVoltage=newRMS;
					Circuit.circuit.branch.(@index==this.ids).@rmsVoltage=this.rmsVoltage;
					Circuit.circuit.branch.(@index==this.ids).@vphase=newVoltageDrop.getAngle();
					if(this.type=="wire")
						this.isVRMSReached=true;
				}
				else
					this.isVRMSReached=true;
			}
		}
		//set the current through the branch and update the RMS value untill the RMS value of current has reached
		public function setCurrent(newCurrent:ComplexNumber):void{
			
			this.current=newCurrent;
			var newRMS=newCurrent.getMagnitude()/Math.pow(2,0.5);
			if(!this.isIRMSReached){
				if(newRMS>=this.rmsCurrent){
					this.rmsCurrent=newRMS;
					Circuit.circuit.branch.(@index==this.ids).@rmsCurrent=this.rmsCurrent;
					Circuit.circuit.branch.(@index==this.ids).@cphase=newCurrent.getAngle();
				}
				else
					this.isIRMSReached=true;
			}
		}
		//set the current through the branch and update the Phase Current value
		public function setPhaseCurrent(newCurrent:Number):void{			
			this.phaseCurrent=Utilities.roundDecimal(newCurrent);
		}
		//Switch between real and schematic views
		public function toggleView():void{
			if(!Circuit.isSchematic()){
				setLabelVisible(false);
				if(this.type=="resistor"){
					this.val.x= this.innerComponent.x-35;
					this.val.y= this.innerComponent.y-40;	
				}
				else if(this.type=="capacitor"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-75;
					setJnPos(45,0,60,0);
				}
				else if(this.type=="inductor"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-30;
					setJnPos(15,0,85,0);
				}
				else if(this.type=="bulb"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-80;	
				}
				else if(this.type=="battery"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-40;	
				}
				else if(this.type=="ac power"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-60;	
				}
			}
			else{
				setLabelVisible(true);
				if(this.type=="resistor"){
					this.val.x= this.innerComponent.x-35;
					this.val.y= this.innerComponent.y-40;	
				}
				else if(this.type=="capacitor"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-40;	
					setJnPos(20,0,80,0);
				}
				else if(this.type=="inductor"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-30;
					setJnPos(10,0,90,0);
				}
				else if(this.type=="bulb"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-60;	
				}
				else if(this.type=="battery"){
					this.val.x= this.innerComponent.x-30;
					this.val.y= this.innerComponent.y-50;	
				}
				else if(this.type=="ac power"){
					this.val.x= this.innerComponent.x-15;
					this.val.y= this.innerComponent.y-50;	
				}
			}
				
			this.innerComponentRef.toggleView();
		}
		//Set the branch as selected and apply the glow filter
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
		//get the appropriate object of inner Component
		private function getInnerComponent(type:String):CircuitComponent{
			
			if(type=="resistor")
			{
				return new Resistor();
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
			
			else if(type=="capacitor")
			{
				return new Capacitor();
			}
			else if(type=="inductor")
			{
				return new Inductor();
			}
			else if(type=="ac power")
			{
				return new ACPowerSource();
			}
			
			else
				return null;
				
			return null;
		
		}
		
		//Event to start Rotation of a branch when there is Mouse Down on any junction
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
				if(this.parent.parent!=null){
					this.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAllWire);
				}
			}
		}
		
		//Event to stop Rotation of a branch when there is Mouse Up on any junction
		public function stopRotate(e:Event) {
			
			e.target.removeEventListener(Event.ENTER_FRAME,e.target.hitOnJunction )
			
			this.innerComponent.removeRotationListeners(e.target.parent.innerComponent);
			
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
		
		//Rotate the Branch, except wire, as the mouse moves 
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
		
		
		//Rotate if the type of branch is wire
		function rotateWire(e:Event) {
			if(e.target.opp==false){
				this.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.endJunction.x,e.target.parent.endJunction.y);				
			}
			else{
				this.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.startJunction.x,e.target.parent.startJunction.y);		
			}
		}	
		
		//Stop the all listners that was started when there is a mouse up event on the Stage
		function stopAll(e:MouseEvent) {
							
				if(this.startJunction.hasEventListener(Event.ENTER_FRAME)){
					this.startJunction.removeEventListener(Event.ENTER_FRAME,rotate);
					this.startJunction.removeEventListener(Event.ENTER_FRAME,this.startJunction.hitOnJunction )
					if(this.startJunction.neighbours.length!=0)
						this.innerComponent.removeRotationListeners(this.innerComponent);
				
				}
				if(this.endJunction.hasEventListener(Event.ENTER_FRAME)){
					this.endJunction.removeEventListener(Event.ENTER_FRAME,rotate);
					this.endJunction.removeEventListener(Event.ENTER_FRAME,this.endJunction.hitOnJunction )
					if(this.endJunction.neighbours.length!=0)
						this.innerComponent.removeRotationListeners(this.innerComponent);
				}
		}
		
		//Stop the all listners that was started, if the type of branch is wire, when there is a mouse up event 						  		//on the Stage and check if its is inside Area.
		function stopAllWire(e:MouseEvent) {
			
			
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
		
		//Set the position of the Branch
		public function setPos():void{
			this.x=this.prevX;
			this.y=this.prevY;
		}
		//Set the previous position of the Branch to the new position
		public function setPrev(posX:Number,posY:Number):void{
			this.prevX=posX;
			this.prevY=posY;
		}
		
	}
	
}