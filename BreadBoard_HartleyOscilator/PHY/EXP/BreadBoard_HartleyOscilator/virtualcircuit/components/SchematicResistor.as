package virtualcircuit.components {
	
	import flash.display.MovieClip;
	
	public class SchematicResistor extends MovieClip{
		
		// Constants:
		
		// Public Properties:
		var prevWidth:Number;
		var whiteRect:Rect;
		// Private Properties:
	
		// Initialization:
		public function SchematicResistor() { 
			
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
		
		public function getPrevWidth():Number{
			return this.prevWidth;
		}
		
		public function setPrevWidth(w:Number){
			this.prevWidth=w;
		}
		
		// Protected Methods:
	}
	
}