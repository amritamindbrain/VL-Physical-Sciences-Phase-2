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
	import virtualcircuit.logic.Utilities;
	
	public class ACPowerSource extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicACPowerSource; //Scheamtic AC Power Source Object
		public var realComponent:RealACPowerSource; //Real AC Power Source Object
		public var resistance:Number;	//internal resistance of AC Power Source 
		public var voltage:Number;	//instantaneous Voltage of AC Power Source 
		public var rmsVoltage:Number;	//rms Voltage of AC Power Source 
		public var peekVoltage:Number;	//peek Voltage of AC Power Source
		public var frequency:Number;	//frequency of AC Power Source =2* Pi * Omega
		public var omega:Number;		//angular frequency (Omega) of AC Power Source 
		public var phase:Number;		//Phase angle of the Voltage Source
		public var isReverse:Boolean;	//Boolean indicating if the Source is reversed or not.
		public var fire:Fire;			//Fire MovieClip's Object
		public var isOnFire:Boolean;	//Boolean indicating if the Source is on fire or not.
		public var isON:Boolean;	//Boolean indicating if the source is on or off.
		public var MIN_VOLTAGE:Number;
		// Private Properties:
		var lastEnteredVoltage:Number;
		
		
		// Initialization:
		// Constructor
		public function ACPowerSource() { 
			this.schematicComponent=new SchematicACPowerSource();
			this.realComponent=new RealACPowerSource();
			this.voltage=0;
			this.rmsVoltage=10;
			this.peekVoltage=this.rmsVoltage*Math.pow(2,0.5);
			this.frequency=1;
			this.omega=2*Math.PI*this.frequency;
			this.lastEnteredVoltage=this.rmsVoltage;
			this.MIN_VOLTAGE=0;
			this.resistance=0.01;
			this.realComponent.width=100;
			this.realComponent.height=25;
			this.schematicComponent.width=100;
			this.isReverse=false;
			this.fire=new Fire();
			this.fire.width=this.realComponent.width;
			this.fire.height=100;
			this.fire.y=-48;
			this.fire.visible=false;
			this.isOnFire=false;
			this.isON=false;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.addChild(fire);
			this.mouseEnabled=false;
		}
		
		//Function to switch view between real and schematic 
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
				if(this.isOnFire)
					this.fire.visible=true;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
				this.fire.visible=false;
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
		//Sets the voltage to new voltage and calculate the new peek voltage
		public function setVoltage(newVoltage:Number):void{
			this.rmsVoltage=newVoltage;
			this.lastEnteredVoltage=newVoltage;
			this.peekVoltage=this.rmsVoltage*Math.pow(2,0.5);
		}
		//Sets the frequency to new frequency and calculate the new angular frequency
		public function setFrequency(newFreq:Number):void{
			this.frequency=newFreq;
			this.omega=2*Math.PI*this.frequency;
		}
		
		//Set the AC Source on fire
		public function setFire(){
			if(!isOnFire){
				if(!Circuit.isSchematic())
					this.fire.visible=true;
				this.setChildIndex(this.fire,this.numChildren-1);
				this.rmsVoltage=this.MIN_VOLTAGE;
				this.peekVoltage=this.rmsVoltage*Math.pow(2,0.5);
				Circuit.circuit.branch.(@index==this.parent.ids).@voltage=this.rmsVoltage;
				this.isOnFire=true;
				Circuit.circuit.battery.(@branchIndex==this.parent.ids).@isOnFire=this.isOnFire;
			}
		}
		
		//Off the fire 
		public function offFire(){
			if(isOnFire){
				this.fire.visible=false;
				this.rmsVoltage=this.lastEnteredVoltage;
				this.peekVoltage=this.rmsVoltage*Math.pow(2,0.5);
				if(Circuit.circuit.battery.length!=0)
					Circuit.circuit.branch.(@index==this.parent.ids).@voltage=this.rmsVoltage;
				Circuit.circuit.battery.(@branchIndex==this.parent.ids).@isOnFire=this.isOnFire;
				this.isOnFire=false;
			}
		}
		
		//Find the instantaneous Voltage
		public function sinVoltage(t:Number){
			this.voltage=this.peekVoltage*Math.sin(Utilities.roundDecimal(this.omega*t));
		}
		// Public Methods:
		// Protected Methods:
	}	
}