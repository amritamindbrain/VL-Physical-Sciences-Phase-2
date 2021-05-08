/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	
	public class Capacitor extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicCapacitor; //Scheamtic Capacitor Object
		public var realComponent:RealCapacitor; //Real Capacitor Object
		public var capacitance:Number;	//Capacitance of the Capacitor
		// Private Properties:
	
		// Initialization:
		
		//Constructor
		public function Capacitor() {
			this.schematicComponent=new SchematicCapacitor();
			this.realComponent=new RealCapacitor();
			this.realComponent.width=100;
			this.realComponent.height=25;
			this.schematicComponent.width=100;
			this.schematicComponent.height=25;
			this.capacitance=0.02;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
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
		//set the capacitance of the capacitor
		public function setCapacitance(capacitance:Number):void{
			this.capacitance=capacitance;
		}
	}
	
}