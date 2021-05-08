/*
*	Inductor - Arjun Asok Nair & Sabari S Kumar 
*	
*	This is class represents the Inductor element of an AC Circuit.
* 	All properties and functions associated with it is wriiten here. 
*
*
*/

package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	
	public class Inductor extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicInductor;//Scheamtic Inductor Object
		public var realComponent:RealInductor; //Real Inductor Object
		public var inductance:Number; //Inductance of the Inductor
		public var resistance:Number;
		public var ObjRotation:Number;
		//public var voltage:Number;
		//public var MIN_VOLTAGE:Number;
		// Private Properties:
	
		// Initialization:
		
		//Constructor
		public function Inductor() { 
			//this.schematicComponent=new SchematicInductor();
			this.realComponent=new RealInductor();
			this.realComponent.width=100;
			this.realComponent.height=25;
			//this.schematicComponent.width=100;
			//this.schematicComponent.height=25;
			this.resistance=1000;
			this.inductance=1;
			
			//this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
		}
	
		//Function to switch view between real and schematic 
		public function toggleView():void{
			if(!Circuit.isSchematic()){
				//this.schematicComponent.visible=false;
				this.realComponent.visible=true;
			}
			else {
				this.realComponent.visible=false;
				//this.schematicComponent.visible=true;
			}					
		}
		//set the inductance of the Inductor
		public function setInductance(inductance:Number):void{
			this.inductance=inductance;
		}
		
	}
	
}