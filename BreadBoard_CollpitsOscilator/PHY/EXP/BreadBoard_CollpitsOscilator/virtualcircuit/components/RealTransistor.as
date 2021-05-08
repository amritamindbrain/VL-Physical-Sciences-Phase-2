package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class RealTransistor extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			var gf:GlowFilter;
			var TransistorObj:Transistormc;
			// Initialization:
			function RealTransistor(){
				this.TransistorObj=new Transistormc();
			this.TransistorObj.x=0;
			this.TransistorObj.y=0;
			this.TransistorObj.width=20;
			this.TransistorObj.height=36;
			this.TransistorObj.mouseEnabled=false;
			addChild(this.TransistorObj);
			/*var m1=new MovieClip();
			m1.graphics.beginFill(0x0033CC);
			m1.graphics.lineStyle(1);
			longWireObj.addChild(m1);
			
			var m2=new MovieClip();
			m2.graphics.beginFill(0x0033CC);
			m2.graphics.lineStyle(1);
			longWireObj.addChild(m2)*/
			}
		// Public Methods:
		
		
		// Protected Methods:
	}
	
}
