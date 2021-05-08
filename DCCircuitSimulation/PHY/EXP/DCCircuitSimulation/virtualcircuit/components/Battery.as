
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
	
	public class Battery extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicBattery;
		public var realComponent:RealBattery;
		public var resistance:Number;
		public var voltage:Number;
		public var lastEnteredVoltage:Number;
		public var isReverse:Boolean;
		public var fire:Fire;
		public var isOnFire:Boolean;
		public var lastChanged:Boolean;
		public var MIN_VOLTAGE:Number;
		// Private Properties:
	
		// Initialization:
		public function Battery() { 
			
			//super();
			this.schematicComponent=new SchematicBattery();
			this.realComponent=new RealBattery();
			this.voltage=9;
			this.lastEnteredVoltage=this.voltage;
			this.lastChanged=false;
			this.MIN_VOLTAGE=0.0001;
			this.resistance=0.0000000001;
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
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.addChild(fire);
			this.mouseEnabled=false;
		}
	
		// Public Methods:
		// Protected Methods:
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
		
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}
		
		public function setVoltage(newVoltage:Number){
			this.voltage=newVoltage;
			this.lastEnteredVoltage=newVoltage;
		}
		
		public function setFire():Boolean{
			if(!this.isOnFire){
				if(!Circuit.isSchematic())
					this.fire.visible=true;
				this.setChildIndex(this.fire,this.numChildren-1);
				this.voltage=this.MIN_VOLTAGE;
				Circuit.circuit.branch.(@index==this.parent.ids).@voltage=this.voltage;
				this.isOnFire=true;
				Circuit.circuit.battery.(@branchIndex==this.parent.ids).@isOnFire=this.isOnFire;
				return true;
			}
			return false;
		}
		
		public function offFire():Boolean{
			if(this.isOnFire){
				this.isOnFire=false;
				this.fire.visible=false;
				this.voltage=this.lastEnteredVoltage;
				if(Circuit.circuit.battery.length!=0)
					Circuit.circuit.branch.(@index==this.parent.ids).@voltage=this.voltage;
				Circuit.circuit.battery.(@branchIndex==this.parent.ids).@isOnFire=this.isOnFire;
				return true;
			}
			return false;
		}
	}
	
}