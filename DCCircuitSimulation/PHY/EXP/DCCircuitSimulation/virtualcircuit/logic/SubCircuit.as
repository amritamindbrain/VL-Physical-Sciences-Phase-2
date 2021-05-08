
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic{

	import virtualcircuit.components.Branch;
	
	public class SubCircuit{
		public var ids:int;
		public var branches:Array;
		public var nodes:Array;
		public var isCycle:Boolean;
		public var isChanged:Boolean;
		var ref:Node;
		var batteries:Array;
		var resistorCount:int;
		var switchCount:int;
		var ammeterCount:int;
		var bulbCount:int;
		
		function SubCircuit(){
			this.ids=-1;
			this.isCycle=false;
			this.branches=new Array();
			this.batteries=new Array();
			this.nodes=new Array();
			this.resistorCount=0;
			this.switchCount=0;
			this.ammeterCount=0;
			this.bulbCount=0;
		}
				
		public function nodalAnalysis():void{
			this.ref=nodes[0];
			this.ref.ids=-1;
			this.ref.voltage=0;
			this.removeRef();
			this.numberNodes();
			getNumberOfBatteries();
			setLabels();
			var flag:Boolean=circuitAlgorithm();
			if(flag)
				checkIfBurnBattery();
		}
		
		function circuitAlgorithm():Boolean{
			var mna:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);
			if(!mna.isSingular){
				setBranchVoltage();
				//checkIfBurnBattery();
				updateAmmeterReadings();
				return true;
			}
			return false;
		}
		
		function removeRef(){
			this.nodes.splice(0,1);
			for(i=0;i<nodes.length;i++){
				var index:int=this.nodes[i].adj.lastIndexOf(ref);
				if(index!=-1){
					this.nodes[i].adj.splice(index,1);
				}				
			}		
		}
		
		function getNumberOfBatteries(){
			var count:int=0;
			
			for(var i:int=0;i<this.branches.length;i++){
				if(this.branches[i].type=="battery"){
					this.batteries.push(this.branches[i]);
					this.branches[i].setCompLabel("V"+String(count++));
				}
			}
		}
		
		function numberNodes():void{
			for(var i:int=0;i<this.nodes.length;i++){
				this.nodes[i].ids=i;
			}
		}
		
		function setLabels():void{
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type!= "battery" && branches[i].type!= "wire" )
					branches[i].setCompLabel(getCompLabel(branches[i].type));
				if(branches[i].type!= "wire"){
					var startNode=getNode(branches[i].startJunction.ids,1)
					if(!startNode.isLabelSet){
						branches[i].setStartJnLabel(String(startNode.ids+1));
						startNode.isLabelSet=true;					
					}
					var endNode=getNode(branches[i].endJunction.ids,1)
					if(!endNode.isLabelSet){
						branches[i].setEndJnLabel(String(endNode.ids+1));
						endNode.isLabelSet=true;					
					}
				}
			}
		}
		
		function getCompLabel(type:String):String{
			
			if(type=="resistor"){
				return "R"+String(resistorCount++);
			}	
			else if(type=="bulb"){
				return "B"+String(bulbCount++);
			}	
			else if(type=="switch"){
				return "S"+String(switchCount++);
			}				
			else if(type=="ammeter"){
				return "A"+String(ammeterCount++);
			}	
		}
		function setBranchVoltage():void{
			var voltage:Number;
			var current:Number;
	
			for(var i=0;i<branches.length;i++){
				var branch:XMLList=Circuit.circuit.branch.(@index==branches[i].ids);
				var node1=getNode(branch.@startJunction,1);
				var node2=getNode(branch.@endJunction,1);
				
				if(node1.voltage>=node2.voltage){
					voltage=Utilities.roundDecimal(node1.voltage-node2.voltage,2);
					current=Utilities.roundDecimal((node1.voltage-node2.voltage)/branches[i].innerComponent.resistance,2);
					branches[i].setVoltageDrop(voltage);
					branches[i].setCurrent(current);
					Circuit.circuit.branch.(@index==branch.@index).@voltage=voltage;
					Circuit.circuit.branch.(@index==branch.@index).@current=current;
					Circuit.circuit.branch.(@index==branch.@index).@currentStart=node1.circuitIndex;
					Circuit.circuit.branch.(@index==branch.@index).@currentEnd=node2.circuitIndex;
					if(branches[i].type=="bulb"){
						branches[i].innerComponent.glowBulb(voltage);
					}
				}
				else if(node2.voltage>node1.voltage){
					voltage=Utilities.roundDecimal(node2.voltage-node1.voltage,2);
					current=Utilities.roundDecimal((node2.voltage-node1.voltage)/branches[i].innerComponent.resistance,2);
					branches[i].setVoltageDrop(voltage);
					branches[i].setCurrent(current);
					Circuit.circuit.branch.(@index==branch.@index).@voltage=voltage;
					Circuit.circuit.branch.(@index==branch.@index).@current=current;
					Circuit.circuit.branch.(@index==branch.@index).@currentStart=node2.circuitIndex;
					Circuit.circuit.branch.(@index==branch.@index).@currentEnd=node1.circuitIndex;
					if(branches[i].type=="bulb"){
						branches[i].innerComponent.glowBulb(voltage);
					}
				}				
			}
		}
		function checkIfBurnBattery(){
			var  neighbours:XMLList;
			var  neighbour:XML;
			this.isChanged=false;
			
			for(i=0;i<batteries.length;i++){
				var flag=false;
				var battery:XMLList=Circuit.circuit.branch.(@index==batteries[i].ids);
				neighbours=Circuit.circuit.branch.((@startJunction==battery.@startJunction || @endJunction==battery.@startJunction) && @index!=battery.@index);
				for each(neighbour in neighbours){
					if(neighbour.@current>Circuit.MAX_CURRENT){
						if(batteries[i].innerComponent.setFire())
							this.isChanged=true;					
						flag=true;
						break;
					}	
				}
				if(!flag){
					if(batteries[i].innerComponent.offFire())
						this.isChanged=true;										
				}
			}
		}		
		function updateAmmeterReadings(){
			
			for(var i=0;i<this.branches.length;i++)
			{				
				if(branches[i].type=="ammeter"){
					
					branches[i].innerComponent.updateCurrentReading();
				}
			}
		}
		
		public function offBulbs(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="bulb"){
					branches[i].innerComponent.glowBulb(0);
				}
			}
		}
		public function offBatteries(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="battery"){
					branches[i].innerComponent.offFire();
				}
			}
		}
		
		function getNode(id:int,switchId:int):Node{
			var i:int;
			
			switch(switchId){
				case 0: 
						for(i=0;i<nodes.length;i++){
							if(nodes[i].ids==id){
								return nodes[i];
							}
						}
						break;
				case 1: if(ref.circuitIndex==id){
							return ref;
						}
						else{
							
							for(i=0;i<nodes.length;i++){
								if(nodes[i].circuitIndex==id){
									return nodes[i];
								}
							}
						}
						break;
			}
		}
		
		function getBranch(branchId:Number):Branch{
			
			for(var i=0;i<branches.length;i++){
				if(branches[i].ids==branchId){
					return branches[i];
				}
			}
		}
		
		public function printAll(){
			var i:int;
			trace("nodes");
			for(i=0;i<nodes.length;i++){
				nodes[i].printAll();
			}		
		}
	}
}