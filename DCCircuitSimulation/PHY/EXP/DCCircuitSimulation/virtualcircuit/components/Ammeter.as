
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
	
	public class Ammeter extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicAmmeter;
		public var realComponent:RealAmmeter;
		public var resistance:Number;
		public var currText:TextField;
		// Private Properties:
	
		// Initialization:
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
			this.currText.width=40;
			this.currText.height=40;
			this.currText.y=-9.5;
			this.currText.x=-10;
			
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
				
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
				this.currText.y=-9.5;
				this.currText.x=-10;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
				this.currText.y=-35;
				this.currText.x=-25;
			}
					
		}
		
		function getCurrentValue():Number{
			
			return this.parent.getCurrent();
		}
		
		public function updateCurrentReading(){
			
			var cVal:Number=this.getCurrentValue();
			this.currText.text=cVal+"A";
		}
		
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}
		
	}
	
}