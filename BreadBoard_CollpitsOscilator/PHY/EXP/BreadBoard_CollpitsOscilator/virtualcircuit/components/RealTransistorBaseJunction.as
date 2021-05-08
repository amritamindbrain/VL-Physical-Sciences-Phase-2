package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class RealTransistorBaseJunction extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			var gf:GlowFilter;
			var TransistorObj:TransistoBasermc;
			// Initialization:
			function RealTransistorBaseJunction(){
				this.TransistorObj=new TransistoBasermc();
			this.TransistorObj.x=0;
			this.TransistorObj.y=0;
			this.TransistorObj.width=10;
			this.TransistorObj.height=76;
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
