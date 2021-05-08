package virtualcircuit.components {
	
	import flash.display.MovieClip;
	
	public class SchematicWire extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			
			
		// Initialization:
		public function SchematicWire() { 
			
		}
	
		// Public Methods:
		public function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number){
			
			this.graphics.clear();
			this.graphics.lineStyle(3,0X0000000,1,true,"none","CapsStyle.SQUARE","JointStyle.MITER",3);
			this.graphics.moveTo(xstart,ystart);
			this.graphics.lineTo(xend,yend);

		}
		
		// Protected Methods:
	}
	
}