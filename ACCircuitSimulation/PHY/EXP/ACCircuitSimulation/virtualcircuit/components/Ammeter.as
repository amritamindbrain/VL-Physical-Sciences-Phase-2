/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.controls.TextArea;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.Utilities;
	
	public class Ammeter extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicAmmeter;	//Scheamtic Ammeter Object
		public var realComponent:RealAmmeter;	//Real Ammeter Object
		public var resistance:Number;	//Resistance of the Ammeter
		public var currText:TextField;	//Text Field to display the current
		// Private Properties:
	
		// Initialization:
		
		//Constructor
		public function Ammeter() { 
			
			//super();
			this.schematicComponent=new SchematicAmmeter();
			this.realComponent=new RealAmmeter();
			this.realComponent.width=100;
			this.realComponent.height=25;
			this.schematicComponent.width=100;
			this.schematicComponent.height=25;
			this.resistance=0.0000000001;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			
			this.currText=new TextField();
			this.currText.width=55;
			this.currText.height=40;
			this.currText.y=-9.5;
			this.currText.x=-25;
			
			var timesNew=new TimesNew();
			var format:TextFormat = new TextFormat();
			format.font=timesNew.fontName;
			format.size = 11;
			format.align ="right";
			this.currText.defaultTextFormat = format;
			this.currText.setTextFormat(format);
			this.currText.embedFonts=true;
			this.currText.mouseEnabled=false;
			this.mouseEnabled=false;
			this.addChild(currText);

		}
	
		// Public Methods:
		// Protected Methods:
		
		//Function to switch view between real and schematic 
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
				this.currText.y=-9.5;
				this.currText.x=-25;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
				this.currText.y=-35;
				this.currText.x=-40;
			}
					
		}
		
		//get the current through the Ammeter's Branch 
		function getCurrentValue():Number{
			
			return this.parent.getRMSCurrent();
		}
		
		//update the current and display it on the TextField 
		public function updateCurrentReading(){
			
			var cVal:Number=Utilities.roundDecimal(this.getCurrentValue(),4);
			this.currText.text=cVal+"A";
		}
		//Sets the Position of the real and Schematic Components
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}
		
	}
	
}