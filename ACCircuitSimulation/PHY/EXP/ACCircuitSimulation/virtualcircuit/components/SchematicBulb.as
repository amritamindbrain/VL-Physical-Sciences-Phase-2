﻿/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import flash.display.MovieClip;
	
	public class SchematicBulb extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var whiteRect:Rect; //A rectangle whose alpha is 0
		
		// Initialization:
		//Constructor
		public function SchematicBulb() {
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

	}
	
}