
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
		public var schematicComponent:SchematicWire;
		public var realComponent:RealWire;
		public var resistance:Number;
		public var leng:Number;
		public var high:Number;
		var startPointX:Number;
		var startPointY:Number;
		var endPointX:Number;
		var endPointY:Number;
				
		// Private Properties:
	
		// Initialization:
		public function Wire() { 
			this.buttonMode=true;
			this.schematicComponent=new SchematicWire();
			this.realComponent=new RealWire();
			this.schematicComponent.visible=false;
			this.leng=this.realComponent.width;
			this.high=this.realComponent.height;
			this.resistance=0.0000000001;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
		}
	
		// Public Methods:
		// Protected Methods:
				
		public function toggleView(){
			
			if(!Circuit.isSchematic()){
				this.realComponent.drawLine(this.startPointX,this.startPointY,this.endPointX,this.endPointY);
				this.leng=this.realComponent.width;
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;				
			}
			else if(Circuit.isSchematic()){
				this.schematicComponent.drawLine(this.startPointX,this.startPointY,this.endPointX,this.endPointY);
				this.leng=this.schematicComponent.width;
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
			} 
			
		}
		
		public function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number){
			
			this.schematicComponent.drawLine(xstart,ystart,xend,yend);
			this.realComponent.drawLine(xstart,ystart,xend,yend);
			this.leng=(xend-xstart>0)?xend-xstart:xstart-xend;
			this.startPointX=xstart;
			this.startPointY=ystart;		
			this.endPointX=xend;
			this.endPointY=yend;		
		}
		
		public function setResistance(resistance:Number):void{
			this.resistance=resistance;
		}
	}
	
}