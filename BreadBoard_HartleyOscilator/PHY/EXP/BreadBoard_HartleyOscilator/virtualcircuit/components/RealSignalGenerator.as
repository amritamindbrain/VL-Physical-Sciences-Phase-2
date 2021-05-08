package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class RealSignalGenerator extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
			var gf:GlowFilter;
			var realSignalGeneratorObj:signalGeneratorrMc;
			// Initialization:
			function RealSignalGenerator(){
				this.realSignalGeneratorObj=new signalGeneratorrMc();
			this.realSignalGeneratorObj.x=0;
			this.realSignalGeneratorObj.y=0;
			//this.realCapacitorObj.width=100;
			//this.realCapacitorObj.height=100;
			this.realSignalGeneratorObj.mouseEnabled=false;
			addChild(this.realSignalGeneratorObj);
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
