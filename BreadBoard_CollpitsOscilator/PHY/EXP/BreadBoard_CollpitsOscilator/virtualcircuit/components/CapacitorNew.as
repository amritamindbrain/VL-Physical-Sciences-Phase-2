/*
*	Capacitor - Arjun Asok Nair & Sabari S Kumar 
*	
*	This is class represents the Capacitor element of an AC Circuit.
* 	All properties and functions associated with it is wriiten here. 
*
*
*/
package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	
	public class CapacitorNew extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicCapacitor; //Scheamtic Capacitor Object
		public var realComponent:RealCapacitorNew; //Real Capacitor Object
		//public var capacitance:Number;	//Capacitance of the Capacitor
		public var resistance:Number;
		public var charge:Number;
		public var capValue:Number;
		public var isClosed:Boolean;
		isClosed=false;
		public var ObjRotation:Number;
		//public var voltage:Number;	
		//public var MIN_VOLTAGE:Number;
		// Private Properties:
	
		// Initialization:
		

		//Constructor
		public function CapacitorNew() {
			//this.schematicComponent=new SchematicCapacitor();
			this.realComponent=new RealCapacitorNew();
			this.realComponent.width=40;
			this.realComponent.height=50
			//this.schematicComponent.width=100;
			//this.schematicComponent.height=25;
			this.capValue=0.1;
			//this.MIN_VOLTAGE=0.0001;
			this.resistance=10000;
			
			//this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
			
		}
		public function setWireLength(len:Number){
			
			this.width=len;
			this.realComponent.setPrevWidth(this.realComponent.width);
		}
		public function setCapValue(newCapValue:Number){
			this.capValue=newCapValue;
			//this.lastEnteredVoltage=newVoltage;
		}
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			//this.schematicComponent.x=xlen;
			//this.schematicComponent.y=ylen;
			//this.setRegistration(this.realComponent.x,this.realComponent.y);
		}		
		//Function to switch view between real and schematic 
		/*public function toggleView():void{
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
			}					
		}*/
		//set the capacitance of the capacitor
		/*public function setCapacitance(capacitance:Number):void{
			//this.capacitance=capacitance;
		}*/
	}
	
}