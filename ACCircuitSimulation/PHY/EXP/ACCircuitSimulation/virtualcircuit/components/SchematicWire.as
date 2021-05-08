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
	
	public class SchematicWire extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			
			
		// Initialization:
			
		// Public Methods:
		////Draws the wire from the xstart,ystart to xend,yend
		public function drawLine(xstart:Number,ystart:Number,xend:Number,yend:Number){
			
			this.graphics.clear();
			this.graphics.lineStyle(3,0X0000000,1,true,"none","CapsStyle.SQUARE","JointStyle.MITER",3);
			this.graphics.moveTo(xstart,ystart);
			this.graphics.lineTo(xend,yend);

		}
		
		// Protected Methods:
	}
	
}