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