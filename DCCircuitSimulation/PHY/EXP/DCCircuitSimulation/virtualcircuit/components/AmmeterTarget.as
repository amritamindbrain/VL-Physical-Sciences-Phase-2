
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
	
	public class AmmeterTarget extends MovieClip{
		
		// Constants:
		
		// Public Properties:
		var prevWidth:Number;
		
		// Private Properties:
	
		// Initialization:
		public function AmmeterTarget() { 	
			
		}
	
		// Public Methods:
		
		public function getPrevWidth():Number{
			return this.prevWidth;
		}
		
		public function setPrevWidth(w:Number){
			this.prevWidth=w;
		}
		
		// Protected Methods:
	}
	
}