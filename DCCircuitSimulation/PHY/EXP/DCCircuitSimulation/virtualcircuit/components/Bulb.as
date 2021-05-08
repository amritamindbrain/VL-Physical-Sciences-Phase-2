
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
		public var schematicComponent:SchematicBulb;
		public var realComponent:RealBulb;
		public var resistance:Number;
		public var powerRating:Number;
		public var voltageRating:Number;
		var maxCurrent:Number;
		var glow:Glow;
		var isGlow:Boolean;
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
			this.powerRating=10;
			this.voltageRating=10;
			this.resistance=Utilities.roundDecimal((Math.pow(this.voltageRating,2))/this.powerRating,2);
			this.maxCurrent=this.voltageRating/this.resistance;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
			
		}
	
		// Public Methods:
		// Protected Methods:
		
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
		
		public function setWireLength(len:Number){
			
			this.width=len;
			this.realComponent.setPrevWidth(this.realComponent.width);
		}
		
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}
		
		public function glowBulb(voltage:Number):void{
				var newPower=Utilities.roundDecimal((Math.pow(voltage,2)/this.resistance),2);
				var glowVal:Number=Utilities.roundDecimal(newPower/this.powerRating,2);
				if(voltage!=0){
					this.glow.visible=true;
					if(glowVal<0.1){
						this.glow.visible=false;
						this.isGlow=false;
					}					
					else{
						var gf:GlowFilter=new GlowFilter(0XFFFF00,glowVal,8,8,voltage/5,3,false,false);
						this.glow.filters=[gf];
						this.isGlow=true;
					}
				}
				else{
					this.glow.visible=false;
					this.isGlow=false;
				}
		}
		
		public function stopGlowBulb(e:MouseEvent):void{
				this.glow.visible=false;
				this.isGlow=false;
		}
		
		public function setPowerRating(power:Number):Number{
			this.powerRating=power;
			this.resistance=(Math.pow(this.voltageRating,2))/this.powerRating;
			this.maxCurrent=this.voltageRating/this.resistance;
			return resistance;
		}
		public function setVoltageRating(voltage:Number):Number{
			this.voltageRating=voltage;
			this.resistance=(Math.pow(this.voltageRating,2))/this.powerRating;
			this.maxCurrent=this.voltageRating/this.resistance;
			return resistance;
		}
		
	}
	
}