package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ColourBand extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			
		// Initialization:
		public function ColourBand() { 
			this.addEventListener(MouseEvent.MOUSE_DOWN,drag);
			this.addEventListener(MouseEvent.MOUSE_UP,endDrag);
			this.mouseEnabled=false;
		}
		
		// Public Methods:
		
		// Protected Methods:
			function drag(e:MouseEvent):void{
				e.target.parent.parent.parent.parent.setChildIndex(e.target.parent.parent.parent,e.target.parent.parent.parent.parent.numChildren-1);
				//trace("sheri");
				//trace(e.target.parent.parent.parent);
				e.target.parent.parent.parent.startDrag();
			}
			function endDrag(e:MouseEvent):void{
				e.target.parent.parent.parent.stopDrag();
			}
	}
	
}