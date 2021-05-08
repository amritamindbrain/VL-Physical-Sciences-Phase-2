/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import virtualcircuit.logic.Circuit;
	
	public class RealACPowerSource extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var ledBulb:LedBulb;	//Led bulb indicating if the AC source is on or off.
		var wSwitch:WhiteSwitch;	// Switch to on and off the source
		var redGlow:GlowFilter;		//a red filter
		var greenGlow:GlowFilter;	//a green filter
		
		// Initialization:
		//Constructor
		public function RealACPowerSource() { 
			this.ledBulb=new LedBulb();
			this.ledBulb.width=20;
			this.ledBulb.height=25;
			this.ledBulb.x=-90;
			this.ledBulb.y=-35;
			this.ledBulb.mouseEnabled=false;
			
			this.wSwitch=new WhiteSwitch();
			this.wSwitch.x=70;
			this.wSwitch.y=-5;
			this.wSwitch.addEventListener(MouseEvent.CLICK,changeLedColor);
			
			this.redGlow=new GlowFilter(0XFF0000,15,15,10,3,BitmapFilterQuality.HIGH,true,false);
			this.greenGlow=new GlowFilter(0X00CC00,15,15,10,3,BitmapFilterQuality.HIGH,true,false);
			
			this.ledBulb.led.filters=[redGlow];
			
			this.addChild(ledBulb);
			this.addChild(wSwitch);
		}
	
		//Event Listener changes the state of the source between on and off
		function changeLedColor(e:MouseEvent){
			if(this.parent.isON){
				this.parent.isON=false;
				this.ledBulb.led.filters=[redGlow];
			}
			else{
				this.parent.isON=true;
				this.ledBulb.led.filters=[greenGlow];
			}
			Circuit.circuitAlgorithm();
		}
		// Public Methods:
		// Protected Methods:
	}
	
}