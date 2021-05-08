/*
*	ICchip
*	
*	This is class represents the ICchip element of an AC Circuit.
* 	All properties and functions associated with it is written here. 
*
*
*/
package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	//import virtualcircuit.components.Branch;
	import virtualcircuit.logic.SubCircuit;
	
	public class ICchip extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicICchip; //Scheamtic ICchip Object
		public var realComponent:RealICchip; //Real ICchip Object
		public var resistance:Number;
		public var bulb_1:Branch;
		public var battery_1:Branch;
		public var wire_1:Branch;
		public var icArray:Array=new Array;
		
		public var volt_1:Number;
		public var curr_1:Number;
		//var subckt:SubCircuit=new SubCircuit;
		// Private Properties:
	
		// Initialization:
		
		//Constructor
		public function ICchip() {
			this.schematicComponent=new SchematicICchip();
			this.realComponent=new RealICchip();
			//trace(this.realComponent.width,this.realComponent.height)
			this.realComponent.width=62;//41.33
			this.realComponent.height=50;//33.33
			this.schematicComponent.width=62;//41.33
			this.schematicComponent.height=50;//33.33
			this.resistance=0.0000000001;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
			
			
			bulb_1=new Branch("bulb");
			this.addChild(bulb_1);
			Circuit.addComponent(bulb_1);
			Circuit.addBranchToList(bulb_1);
			
			battery_1=new Branch("battery");
			this.addChild(battery_1);
			Circuit.addComponent(battery_1);
			Circuit.addBranchToList(battery_1);
			
			wire_1=new Branch("wire");
			this.addChild(wire_1);
			Circuit.addComponent(wire_1);
			Circuit.addBranchToList(wire_1);
			
			bulb_1.x=battery_1.x=wire_1.x=bulb_1.y=battery_1.y=wire_1.y=-30;
			bulb_1.visible=battery_1.visible=wire_1.visible=false;

			/*this.bulb_1=new RealBulb;
			this.battery_1=new RealBattery;
			this.addChild(this.battery_1);
			//this.bulb_1.visible=false;
			//this.battery_1.visible=false;
			this.bulb_1.width=this.bulb_1.height=50;
			this.battery_1.width=70;
			this.battery_1.height=20;
			this.bulb_1.y=-50;*/
			
			icArray=new Array(bulb_1,battery_1,wire_1);
			var jun:Junction=new Junction();
			for(var i=0;i<icArray.length;i++){
				if(i==icArray.length-1){
					jun.boardHitJunction(icArray[i].endJunction,icArray[0].startJunction);
				} else{
					jun.boardHitJunction(icArray[i].endJunction,icArray[i+1].startJunction);
				}
			}
			/*jun.boardHitJunction(bulb_1.endJunction,battery_1.startJunction);
			jun.boardHitJunction(battery_1.endJunction,wire_1.startJunction);
			jun.boardHitJunction(wire_1.endJunction,bulb_1.startJunction);*/
			
			
			//trace("IIIIIIIIIICcccccc "+subckt.icCurrOut,subckt.icVoltOut);
			
		}
		
		public static function test(volt,curr){
			volt_1=volt;
			curr_1=curr;
			//trace("IIIIIIIIIICcccccc "+volt_1,curr_1);
			
		}
		
		public static function getVolt():Number{
			return volt_1;
		}
		
		public static function getCurr():Number{
			return curr_1;
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
		
	}
	
}