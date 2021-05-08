/*
*	SchematicInductor - Arjun Asok Nair & Sabari S Kumar 
*	
*	This is class represents the SchematicInductor. 
* 	All properties and functions associated with it is wriiten here. 
*
*
*/
package virtualcircuit.components {
	
	import flash.display.MovieClip;
	
	public class SchematicInductor extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var whiteRect:Rect; //A rectangle whose alpha is 0
	
		// Initialization:
		//Constructor
		public function SchematicInductor() { 
			this.whiteRect=new Rect();
			this.whiteRect.width=this.width;
			this.whiteRect.height=this.height;
			this.whiteRect.x=this.x;
			this.whiteRect.y=this.y;
			this.whiteRect.alpha=0;
			this.addChild(this.whiteRect);			
			this.mouseChildren=false;
			this.setChildIndex(this.whiteRect,this.numChildren-2);
		}
	
		// Public Methods:
		// Protected Methods:
	}
	
}