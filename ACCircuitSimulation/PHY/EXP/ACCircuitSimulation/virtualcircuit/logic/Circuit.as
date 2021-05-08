
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
package virtualcircuit.logic {
	
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Ammeter;
	import virtualcircuit.components.Junction;
	
	public class Circuit {
		
		// Constants:
		// Public Properties:
		public static var circuit:XML=<circuit>	</circuit>;//This XML object will contain details of all branches inside the area
		public static var branches:Array=new Array();//Array contains Objects of all the branches inside the area
		static var branchCount:Number= 0;//number of Branches inside area
		static var junctionCount:Number=0;//number of Junctions inside area
		static var batteryCount:int=0;//number of Batteries inside area
		static var nodes:Array=new Array();//Array contains Objects of all the Nodes 
		static var viewFlag:Boolean=false;//Boolean gives the current view false is lifelike and true schematic
		public static var subCircuits:Array=new Array();//Array contains Objects of all the subCircuits
		public static var oldSubCircuits:Array=new Array();//Array contains Objects of all the subCircuits
		public static var MAX_CURRENT:Number=500;
		//find the end junction
		public static function getEndJunction(branch:String):String{
			
			return circuit.branch.(@index==branch).@endJunction;
		}
		//Add a branche to branches array,this array will contain all branches inside the area
		static public function addBranchToList(branch:Object):void{
			
			Circuit.branches.push(branch);
		}
		//returns Object of branch specified branch Id
		static public function getBranch(branchId:Number):Branch{
			
			for(var i=0;i<branches.length;i++){
				if(branches[i].ids==branchId){
					return branches[i];
				}
			}
		}
		//returns Object of the subCircuit specified sub Circuit Id
		static public function getSubCircuit(subId:Number):SubCircuit{
			for(var i=0;i<subCircuits.length;i++){
				if(subCircuits[i].ids==subId){
					return subCircuits[i];
				}
			}
		}
		//removes Object of the subCircuit specified sub Circuit Id from the branches array
		static public function removeBranch(branch:Branch):void{
			for(var i=0;i<branches.length;i++){
				if(branches[i]==branch){
					branches[i].startJunction.removeFromNeighbours();
					branches[i].endJunction.removeFromNeighbours();
					branches.splice(i,1);
					return;
				}
			}
		} 
		//return Current View 
		static public function isSchematic():Boolean{
			
			return Circuit.viewFlag;
		}
		
		//set the viewFlag to schematic
		static public function setSchematic():void{
			
			Circuit.viewFlag=true;
		}
		
		//Toogle the viewFlag
		static public function toggleGlobalView():void{
			
			if(Circuit.viewFlag==true)
				Circuit.viewFlag=false;
			else
				Circuit.viewFlag=true;
		}
		
		//set the viewFlag to real
		static public function setRealView():void{
			
			Circuit.viewFlag=false;
		}
		
		//return the arrey containing all branches 
		static public function getAllBranches():Array{
		
			return Circuit.branches;
		}
		
		//Toogle the view of all branches if view has been changed
		static public function toggleViewForAllBranches():void{
		
			for(var i=0;i<Circuit.branches.length;i++){
				Circuit.branches[i].toggleView();
			}
		}
		
		//add each Component to the circuit XML 
		static public function addComponent(brn:Object):void	//cc:CircuitComponent//brn:Branch
		{
			
			var i:int=0;
			
			var branch:XML = <branch />;
			var junction1:XML=<junction/>;
			var junction2:XML=<junction/>;
			var battery:XML=<battery />
						
			
			branch.@index = branchCount++;
			brn.ids=branch.@index.toString();
			
			branch.@startJunction=junctionCount++;
			brn.startJunction.ids=branch.@startJunction.toString();
			brn.startJunction.name=branch.@startJunction.toString();
			branch.@endJunction=junctionCount++;
			brn.endJunction.ids=branch.@endJunction.toString();
			brn.endJunction.name=branch.@endJunction.toString();
			branch.@prevStartJunction=branch.@startJunction;
			branch.@prevEndJunction=branch.@endJunction;
			
			branch.@type = brn.type;
			branch.@currentStart=null;
			branch.@currentEnd=null;
			
			if(brn.type=="battery"){
				branch.@voltage=brn.innerComponent.voltage;
				branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;
				circuit.appendChild(branch);		
				
				battery.@index= batteryCount++;
				battery.@type= brn.type;
				battery.@branchIndex=branch.@index;
				battery.@positive=branch.@startJunction;
				battery.@negative=branch.@endJunction;
			
				if(circuit.battery.length()!=0){
					circuit.insertChildAfter(circuit.battery[circuit.battery.length()-1],battery);
				}
				else{
					circuit.insertChildAfter(null,battery);
				}
			}
			else if(brn.type=="ac power"){
				branch.@voltage=brn.innerComponent.voltage;
				branch.@vphase=null;
				branch.@frequency=brn.innerComponent.frequency;
				branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;
				branch.@cphase=null;
				circuit.appendChild(branch);		
				
				battery.@index= batteryCount++;
				battery.@type= brn.type;
				battery.@branchIndex=branch.@index;
				battery.@positive=branch.@startJunction;
				battery.@negative=branch.@endJunction;
						
				if(circuit.battery.length()!=0){
					circuit.insertChildAfter(circuit.battery[circuit.battery.length()-1],battery);
				}
				else{
					circuit.insertChildAfter(null,battery);
				}
			}
			else{ 
				branch.@voltage=null;
				branch.@vphase=null;
				if(brn.type=="capacitor")
				branch.@capacitance=brn.innerComponent.capacitance;
				else if(brn.type=="inductor")
				branch.@inductance=brn.innerComponent.inductance;
				else 
					branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;
				branch.@cphase=null;
				if(brn.type=="switch"){
					branch.@status=brn.innerComponent.isClose;	
				}	
				circuit.appendChild(branch);		
			}
		}
		
		// Public Methods:
		
		//Removes the specified Object of Branch from the circuit XML,Branches Array and calls the algorithm again
		static public function removeComponent(branchId:Number):void{
			var i:Number;
			var flag:Boolean=false;
			var branch:Branch;
			var xml:XMLList;
			var val:XML;
			var nextStartJunction:Junction;
			var nextEndJunction:Junction;
			
			removedBranch=getBranch(branchId);
			removeBranch(removedBranch);
			
			var cbranch:XMLList=circuit.branch.(@index==branchId);
			if(cbranch.@type=="battery"){
				for(j=0;j<circuit.battery.length();j++){
					if(circuit.battery.@branchIndex[j]==branchId){
						delete circuit.battery[j];
					}
				}
				batteryCount--;
			}
			else if(cbranch.@type=="ac power"){
				for(j=0;j<circuit.battery.length();j++){
					if(circuit.battery.@branchIndex[j]==branchId){
						delete circuit.battery[j];
					}
				}
				batteryCount--;
			}
			for(i=0;i<circuit.branch.length();i++){
				if(circuit.branch.@index[i]==branchId){
					delete circuit.branch[i];
					break;
				}			
			}
			
						
			if(removedBranch.startJunction.neighbours.length!=0){
				nextStartJunction=removedBranch.startJunction.neighbours[0];
				removedBranch.startJunction.neighbours[0].addListenerToJunction();
				
				if(nextStartJunction.parent.type!="wire")
					nextStartJunction.parent.parent.setChildIndex(nextStartJunction.parent,nextStartJunction.parent.parent.numChildren-1);
				//is start juns same
				xml=circuit.branch.(@startJunction==cbranch.@startJunction)
				for each(val in xml){
					circuit.branch.(@index==val.@index).@startJunction=nextStartJunction.name;
					branch=getBranch(val.@index);
					branch.startJunction.ids=nextStartJunction.name;
				}
				//check if start and end same
				xml=circuit.branch.(@endJunction==cbranch.@startJunction)
				for each(val in xml){
					circuit.branch.(@index==val.@index).@endJunction=nextStartJunction.name;
					branch=getBranch(val.@index);
					branch.endJunction.ids=nextStartJunction.name;
				}
			}
			
			if(removedBranch.endJunction.neighbours.length!=0){
				nextEndJunction=removedBranch.endJunction.neighbours[0];
				removedBranch.endJunction.neighbours[0].addListenerToJunction();
				if(nextEndJunction.parent.type!="wire")
					nextEndJunction.parent.parent.setChildIndex(nextEndJunction.parent,nextEndJunction.parent.parent.numChildren-1);
				
				//is end and start juns same
				xml=circuit.branch.(@startJunction==cbranch.@endJunction)
				for each(val in xml){
					circuit.branch.(@index==val.@index).@startJunction=nextEndJunction.name;
					branch=getBranch(val.@index);
					branch.startJunction.ids=nextEndJunction.name;	
				}
				//check if end jns same
				xml=circuit.branch.(@endJunction==cbranch.@endJunction)
				for each(val in xml){
					circuit.branch.(@index==val.@index).@endJunction=nextEndJunction.name;
					branch=getBranch(val.@index);
					branch.endJunction.ids=nextEndJunction.name;
				}
			}
			//recalculate
			circuitAlgorithm();
		}
		
		//updates the circuit XML and the Junction Objects when a split operation is done and calls the algorithm 
		static public function splitJunction(junction:Junction):void{
			var i:Number;
			var j:Number;
			var flag:Boolean=false;
			var val:XML;
			var xml:XMLList;
			
			
			xml=circuit.branch.(@startJunction==junction.ids);
			for each(val in xml){
				circuit.branch.(@index==val.@index).@startJunction=val.@prevStartJunction;
			}
			xml=circuit.branch.(@endJunction==junction.ids);
			for each(val in xml){
				circuit.branch.(@index==val.@index).@endJunction=val.@prevEndJunction;
			}
			junction.splitJunctions();
			circuitAlgorithm();	
			
		}
		
		//reset all variables when a reset operation is performed
		public static function reset():void{
			circuit=<circuit>	</circuit>;
			branches=new Array();
			branchCount=0;
			junctionCount=0;
			batteryCount=0;
			nodes=new Array();
			viewFlag=false;
			removeAllTimers();
			subCircuits=new Array();
			oldSubCircuits=new Array();
		}
		
		//Number the nodes except the reference node in a sequential manner
		public static function numberNodes(){
			var node:Node;
			nodes=new Array();
			var count=0;
			var sflag:Boolean;
			var eflag:Boolean;
			
			for(i=0;i<circuit.branch.length();i++){
				sflag=false;
				eflag=false;
				
				for(var j=0;j<nodes.length;j++){
					if(circuit.branch.@startJunction[i]==nodes[j].circuitIndex){
						sflag=true;
					}
				}
				if(!sflag){
					node=new Node(count,circuit.branch.@startJunction[i]);
					nodes.push(node);
					count++;
				}
				
				for(var k=0;k<nodes.length;k++){
					if(circuit.branch.@endJunction[i]==nodes[k].circuitIndex)
						eflag=true;
				}
				if(!eflag){
					node=new Node(count,circuit.branch.@endJunction[i]);
					nodes.push(node);
					count++;
				}
				
			}
		}
		
		//return the node for a given Circuit XML index or the sequential Index
		public static function getNode(id:int,switchId:int):Node{
			var i:int;
			
			switch(switchId){
				case 0: 
						for(i=0;i<nodes.length;i++){
							if(nodes[i].ids==id){
								return nodes[i];
							}
						}
						break;
				case 1: for(i=0;i<nodes.length;i++){
								if(nodes[i].circuitIndex==id){
									return nodes[i];
								}
						}
						break;						
			}
		}
		
		//find the adjacent nodes of each node
		public static function findAdjacent(){
			
			var k:Number;
			var xml:XMLList;
			var node:Node;
			
			for(var i=0;i<nodes.length;i++){
				if(circuit.branch.(@startJunction==nodes[i].circuitIndex).length()!=0){
					xml=circuit.branch.(@startJunction==nodes[i].circuitIndex).@endJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}
				}
				if(circuit.branch.(@endJunction==nodes[i].circuitIndex).length()!=0){
					xml=circuit.branch.(@endJunction==nodes[i].circuitIndex).@startJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}			
				}
			}
		}
		
		//Call the modified Nodal Analysis Methode of each subcircuit
		static public function circuitAlgorithm():void{ 
			var i:int;
			var flag:Boolean=false;
			numberNodes();
			findAdjacent();
			removeTimers();
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].offBulbs();
					subCircuits[i].offBatteries()
				}
			}
			var dfs:DFS=new DFS();
			subCircuits=dfs.findCircuits();
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].getNumberOfACSources();
					if((subCircuits[i].isCycle || (subCircuits[i].branches.length==1)) && subCircuits[i].acSources[0].innerComponent.isON){
						subCircuits[i].nodalAnalysis();
					}
					else{
						subCircuits[i].offBulbs();
					}
				}
			}
		}
		//remove all the already active Timer event from each sub circuit thats was changed
		static function removeAllTimers():void{
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].checkTimer();
				}
			}
		}
		//remove the already active Timer event from each sub circuit thats was changed
		static function removeTimers():void{
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].checkTimer();
				}
			}
		}
			
		//update the new resistance of the branch, specified by the brachId, in the XML
		static public function setBranchResistance(branchId:Number,resistance:Number):void{
			circuit.branch.(@index==branchId).@resistance=resistance;
		}
		//update the new capacitance of the branch, specified by the brachId, in the XML
		static public function setBranchCapacitance(branchId:Number,capacitance:Number):void{
			circuit.branch.(@index==branchId).@capacitance=capacitance;
		}
		//update the new inductance of the branch, specified by the brachId, in the XML
		static public function setBranchInductance(branchId:Number,inductance:Number):void{
			circuit.branch.(@index==branchId).@inductance=inductance;
		}
		////update the new voltage of the branch, specified by the brachId, in the XML
		static public function setBatteryVoltage(branchId:Number,voltage:Number):void{
			circuit.branch.(@index==branchId).@voltage=voltage;
		}
		//update the new frequency of the branch, specified by the brachId, in the XML
		static public function setBatteryFrequency(branchId:Number,frequency:Number):void{
			circuit.branch.(@index==branchId).@frequency=frequency;
		}
		
		//reverse the polarity in the circuit
		static public function reversePolarity(branchId:Number):void{
			var temp:Number;
			var xml:XMLList=circuit.battery.(@branchIndex==branchId);
			temp=xml.@positive;
			xml.@positive=xml.@negative;
			xml.@negative=temp;
		}
		
		// Protected Methods:
	}
	
}