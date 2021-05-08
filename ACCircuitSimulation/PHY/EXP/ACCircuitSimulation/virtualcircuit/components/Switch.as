/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	
	public class Switch extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicSwitch; //Scheamtic Switch Object
		public var realComponent:RealSwitch; //Real Switch Object
		public var resistance:Number; //Resistance of switch
		public var isClose:Boolean; //Boolean indicating if the switch is closed or not.
		
		// Private Properties:
	
		// Initialization:
		//Constructor
		public function Switch() { 
			
			//super();
			this.schematicComponent=new SchematicSwitch();
			this.realComponent=new RealSwitch();
			
			this.realComponent.width=70;
			this.realComponent.height=55;
			this.schematicComponent.width=70;
			this.schematicComponent.height=20;
			this.resistance=100000;
			this.isClose=false;
			this.mouseEnabled=false;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			
		}
	
		
		//Function to switch view between real and schematic 
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
			}
					
		}
		//Sets the Position of the real and Schematic Components
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}		
	}
	
}