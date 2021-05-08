/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	import flash.geom.Point;
	import virtualcircuit.logic.Circuit;
	
	public class Wire extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicWire; //Scheamtic wire Object
		public var realComponent:RealWire; //Real wire Object
		public var resistance:Number; //Resistance of wire
		var startPointX:Number;	//x position of the starting point of wire
		var startPointY:Number;	//y position of the starting point of wire
		var endPointX:Number;	//x position of the ending point of wire
		var endPointY:Number;	//y position of the ending point of wire
				
		// Private Properties:
	
		// Initialization:
		//Constructor
		public function Wire() { 
			this.buttonMode=true;
			this.schematicComponent=new SchematicWire();
			this.realComponent=new RealWire();
			this.schematicComponent.visible=false;
			this.resistance=0.0000000001;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
		}
	
		// Public Methods:
		// Protected Methods:
		
		//Function to switch view between real and schematic 
		public function toggleView(){
			
			if(!Circuit.isSchematic()){
				this.realComponent.drawLine(this.startPointX,this.startPointY,this.endPointX,this.endPointY);
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
			}
			else{
				this.schematicComponent.drawLine(this.startPointX,this.startPointY,this.endPointX,this.endPointY);
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
			} 
			
		}
		
		//Calls the draw line fns of Schematic and real components and draws the wire
		public function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number){
			
			this.schematicComponent.drawLine(xstart,ystart,xend,yend);
			this.realComponent.drawLine(xstart,ystart,xend,yend);
			this.startPointX=xstart;
			this.startPointY=ystart;		
			this.endPointX=xend;
			this.endPointY=yend;		
		}
		
		//Set the resistance of the wire
		public function setResistance(resistance:Number):void{
			this.resistance=resistance;
		}
	}
	
}