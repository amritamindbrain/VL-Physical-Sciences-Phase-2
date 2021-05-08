package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class RealLongWire extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			var gf:GlowFilter;
			var longWireObj:longwire;
			// Initialization:
			function RealLongWire(){
			this.longWireObj=new longwire();
			this.longWireObj.x=0;
			this.longWireObj.y=0;
			this.longWireObj.width=100;
			this.longWireObj.height=36;
			this.longWireObj.mouseEnabled=false;
			addChild(this.longWireObj);
			}
		// Public Methods:
		
		
		// Protected Methods:
	}
	
}
