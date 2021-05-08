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
	
	public class SignalGenerator extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicCapacitor; //Scheamtic Capacitor Object
		public var realComponent:RealSignalGenerator; //Real Capacitor Object
		//public var capacitance:Number;	//Capacitance of the Capacitor
		public var signalVoltage:Number;
		public var signalFrq:Number;
		public var resistance:Number;
		//public var capValue:Number;
		//public var isClosed:Boolean;
		//isClosed=false;
		//public var voltage:Number;	
		//public var MIN_VOLTAGE:Number;
		// Private Properties:
	
		// Initialization:
		

		//Constructor
		public function SignalGenerator() {
			//this.schematicComponent=new SchematicCapacitor();
			this.realComponent=new RealSignalGenerator();
			this.realComponent.width=70;
			this.realComponent.height=55;
			//this.schematicComponent.width=100;
			//this.schematicComponent.height=25;
			//this.capacitance=0.02;
			//this.MIN_VOLTAGE=0.0001;
			this.signalVoltage=1000;
			this.resistance=0.000000001
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