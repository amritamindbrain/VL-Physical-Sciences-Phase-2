/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.Utilities; 
	
	public class Bulb extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicBulb; //Scheamtic Bulb Object
		public var realComponent:RealBulb; //Scheamtic Bulb Object
		public var resistance:Number; //resistnace of Bulb
		//public var powerRating:Number;
		//public var voltageRating:Number;
		//var maxCurrent:Number;
		var glow:Glow;	//Object of Glow MovieClip
		var isGlow:Boolean;	//Boolean indicating if the bulb is glowing or not
		// Private Properties:
	
		// Initialization:
		public function Bulb() { 
			
			//super();
			this.schematicComponent=new SchematicBulb(); 
			this.realComponent=new RealBulb();
			this.glow=new Glow();
			this.glow.mouseChildren=false;
			this.glow.x=this.x;
			this.glow.y=this.y-40;
			this.glow.width=111;
			this.glow.height=184;
			this.glow.scaleX=.28;
			this.glow.scaleY=.38;
			this.addChild(glow);
			this.glow.visible=false;
			this.realComponent.width=55;
			this.realComponent.height=65;
			this.schematicComponent.width=65;
			this.schematicComponent.height=40;
			
			this.resistance=10;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
			
		}
	
		// Public Methods:
		// Protected Methods:
		
		//Switch view between real and schematic
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
				if(this.isGlow && !this.glow.visible)
					this.glow.visible=true;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
				this.glow.visible=false;
			}
					
		}
		//set the position of real and schematic components
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}
		//Glow the bulb according to the voltage
		public function glowBulb(voltage:Number):void{
				if(!Circuit.isSchematic())
					this.glow.visible=true;
				this.glow.alpha=voltage;
				this.isGlow=true;
		}
		//set the resistance of the bulb		
		public function setResistance(resistance:Number):void{
			this.resistance=resistance;
		}
		
		
	}
	
}