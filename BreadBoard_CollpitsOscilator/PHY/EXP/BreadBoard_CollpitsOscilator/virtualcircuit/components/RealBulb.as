package virtualcircuit.components {
	import flash.display.MovieClip;
	
	public class RealBulb extends MovieClip{
		
		// Constants:
		// Public Properties:
		var prevWidth:Number;
		// Private Properties:
	
		// Initialization:
		public function RealBulb() { 
			this.mouseChildren=false;
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