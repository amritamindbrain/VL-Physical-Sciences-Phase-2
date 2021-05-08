/*
*	Comparator
*	
*	This is class represents the Comparator element of the Circuit.
* 	All properties and functions associated with it is written here. 
*
*
*/
package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	
	public class Comparator extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicComparator; //Scheamtic Comparator Object
		public var realComponent:RealComparator; //Real Comparator Object
		public var resistance:Number;
		public var referenceVoltage:Number;
		// Private Properties:
	
		// Initialization:
		
		//Constructor
		public function Comparator() {
			this.schematicComponent=new SchematicComparator();
			this.realComponent=new RealComparator();
			this.realComponent.width=80;
			this.realComponent.height=60;
			this.schematicComponent.width=100;
			this.schematicComponent.height=25;
			this.referenceVoltage=10;
			//this.MIN_VOLTAGE=0.0001;
			this.resistance=0.0000000001;
			
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
		//set the capacitance of the Comparator
		public function setReferenceVoltage(referenceVoltage:Number):void{
			this.referenceVoltage=referenceVoltage;
		}
	}
	
}