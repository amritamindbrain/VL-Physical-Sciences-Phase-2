package virtualcircuit.logic {
	
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Ammeter;
	import virtualcircuit.components.Junction;
	
	public class Circuit {
		
		// Constants:
		// Public Properties:
		public static var circuit:XML=<circuit>	</circuit>;
		public static var branches:Array=new Array();
		static var branchCount:Number= 0;
		static var junctionCount:Number=0;
		static var midJunCount:Number=0;
		static var batteryCount:int=0;
		static var nodes:Array=new Array();
		static var viewFlag:Boolean=false;
		public static var subCircuits:Array=new Array();
		public static var longWireArray:Array=new Array();
		public static var addedInCircuitIds:Array=new Array();
		// Private Properties:
		static private var stageFlag:Boolean;
		public static var MAX_CURRENT:Number=500;
		
		//find the end junction
		public static function getEndJunction(branch:String):String{
			
			return circuit.branch.(@index==branch).@endJunction;
		}
		//Add all branches to an array
		static public function addBranchToList(branch:Object):void{
			
			Circuit.branches.push(branch);
		}
		//get branch
		static public function getBranch(branchId:Number):Branch{
			
			for(var i=0;i<branches.length;i++){
				if(branches[i].ids==branchId){
					return branches[i];
				}
			}
		}
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
			branch.@baseJunction=midJunCount;
			branch.@prevStartJunction=branch.@startJunction;
			branch.@prevEndJunction=branch.@endJunction;
			if(brn.type=="Transistor"){
				midJunCount=junctionCount++;
				branch.@baseJunction=midJunCount;
				brn.baseJunction.ids=branch.@baseJunction.toString();
				basJunIds=branch.@baseJunction;
				brn.baseJunction.name=branch.@baseJunction.toString();
				//tranNamwIds=branch.@baseJunction.toString();
				////branch.@baseJunction=branch.@baseJunction;
				branch.@prevBaseJunction=branch.@baseJunction;
				
				//Transistor.@base=branch.@baseJunction;//itemType="capasitor";
				
			   }
			  // branch.@prevBaseJunction=branch.@baseJunction;
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
				battery.@branchIndex=branch.@index;
				battery.@positive=branch.@startJunction;
				battery.@negative=branch.@endJunction;
				battery.@isOnFire=brn.innerComponent.isOnFire;	
				if(circuit.battery.length()!=0){
					circuit.insertChildAfter(circuit.battery[circuit.battery.length()-1],battery);
				}
				else{
					circuit.insertChildAfter(null,battery);
				}
			}
			else{
				
				branch.@voltage=null;
				//branch.@vphase=null;
				/*if(brn.type=="capacitor"){
				//branch.@capacitance=brn.innerComponent.capacitance;
				}else if(brn.type=="inductor")
				branch.@inductance=brn.innerComponent.inductance;
				else*/
					branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;
				//branch.@cphase=null;
				/*branch.@voltage=null;
				branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;*/
				if(brn.type=="bulb"){
					branch.@powerRating=brn.innerComponent.powerRating;	
					branch.@voltageRating=brn.innerComponent.voltageRating;	
				}
				else if(brn.type=="switch"){
					branch.@status=brn.innerComponent.isClose;	
				}	
				circuit.appendChild(branch);		
			}
		}
		static public function addlwireComponent(brn:Object):void	//cc:CircuitComponent//brn:Branch
		{
			
			var i:int=0;
			
			var branch:XML = <branch />;
			var junction1:XML=<junction/>;
			////var junction2:XML=<junction/>;
			//var battery:XML=<battery />
			
			
			branch.@index = branchCount++;
			brn.ids=branch.@index.toString();
			
			branch.@startJunction=junctionCount++;
			brn.startJunction.ids=branch.@startJunction.toString();
			brn.startJunction.name=branch.@startJunction.toString();
			branch.@endJunction=0;
			  // branch.@prevBaseJunction=branch.@baseJunction;
			branch.@prevStartJunction=branch.@startJunction;
			branch.@type = brn.type;
			branch.@currentStart=null;
			branch.@currentEnd=null;
			circuit.appendChild(branch);		
			
		}
		// Public Methods:
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
			for(i=0;i<circuit.branch.length();i++){
				if(circuit.branch.@index[i]==branchId){
					delete circuit.branch[i];
					break;
				}			
			}
			
						
			if(removedBranch.startJunction.neighbours.length!=0){
				nextStartJunction=removedBranch.startJunction.neighbours[0];
				removedBranch.startJunction.neighbours[0].addListenerToJunction();
				trace("removeCompon ent")
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
		//split to junctions
		static public function splitJunction(junction:Junction):void{
			var i:Number;
			var j:Number;
			var flag:Boolean=false;
			var val:XML;
			var xml:XMLList;
			
			trace("Junction:-"+junction.name);
			
			xml=circuit.branch.(@startJunction==junction.ids);
			for each(val in xml){
				//trace("devi mata--"+addedInCircuitIds+"--IDS--"+junction.ids);
				//trace(addedInCircuitIds.indexOf(junction.ids+""))
				//if(addedInCircuitIds.indexOf(junction.ids+"")<0)
				//circuit.branch.(@index==val.@index).@startJunction=val.@prevStartJunction;
			}
			xml=circuit.branch.(@endJunction==junction.ids);
			for each(val in xml){
				//if(addedInCircuitIds.indexOf(junction.ids+"")<0)
				//circuit.branch.(@index==val.@index).@endJunction=val.@prevEndJunction;
			}
			//junction.splitJunctions();
			//recalculate
			
			circuitAlgorithm();	
			
		}
		
		//reset all variables
		public static function reset():void{
			
			circuit=<circuit>	</circuit>;
			branches=new Array();
			branchCount=0;
			junctionCount=0;
			batteryCount=0;
			nodes=new Array();
			viewFlag=false;
			subCircuits=new Array();
		}
		
		//Number the nodes except the reference node in a sequential manner
		public static function numberNodes(){
			var node:Node;
			nodes=new Array();
			var count=0;
			var sflag:Boolean;
			var eflag:Boolean;
			var bflag:Boolean;
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
					if(circuit.branch.@endJunction[i]==nodes[k].circuitIndex){
						eflag=true;
						
					}
				}
				if(!eflag){
					node=new Node(count,circuit.branch.@endJunction[i]);
					nodes.push(node);
					count++;
				}
				/*for(var b=0;b<nodes.length;b++){
					if(circuit.branch.@baseJunction[i]==nodes[b].circuitIndex){
						bflag=true;
						
					}
				}
				if(!bflag){
					node=new Node(count,circuit.branch.@baseJunction[i]);
					nodes.push(node);
					count++;
				}*/
				
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
		
		public static function updateResistance(index:String,updatedValue:String){
			
			 circuit.branch.(@index==index).@resistance=updatedValue;			 
		}
		
		//find the adjucent nodes of each node
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
					/*xml=circuit.branch.(@startJunction==nodes[i].circuitIndex).@baseJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}*/
										
				}
				if(circuit.branch.(@endJunction==nodes[i].circuitIndex).length()!=0){
					/*xml=circuit.branch.(@endJunction==nodes[i].circuitIndex).@baseJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}*/
					xml=circuit.branch.(@endJunction==nodes[i].circuitIndex).@startJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}
					
					
				}
				//if(circuit.branch.(@baseJunction==nodes[i].circuitIndex).length()!=0){
					/*xml=circuit.branch.(@baseJunction==nodes[i].circuitIndex).@endJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}*/
					/*xml=circuit.branch.(@baseJunction==nodes[i].circuitIndex).@startJunction;
					for(k=0;k<xml.length();k++){
						node=getNode(xml[k],1);
						nodes[i].adj.push(node);
					}										*/
				//}
			}
		}
/*		public static function setTransistor(){
		var voltageInBase=0;
		for(var p=0;p<branches.length;p++){
			
				 if(branches[p].type=="Transistor"){
						
						var nodeBase=Circuit.getNode(branches[p].baseJunction.ids,0);
						
						trace("branches[i].baseJunction-"+branches[p].baseJunction);
						var nodeEnd=getNode(branches[p].endJunction.ids,1);
						
						var nodeStart=getNode(branches[p].startJunction.ids,1);
						trace(nodeStart.voltage);
						 for(var k=0;k<branches.length;k++){
								if(branches[k].startJunction.hitTestObject(branches[p].baseJunction)){
									var nodeBase1=getNode(branches[k].startJunction.ids,0);
									trace("volatge calculated");
									voltageInBase=nodeEnd.voltage-nodeBase1.voltage;
									trace("voltageInBase-"+voltageInBase+"----"+nodeBase1.voltage);
									
								}else if(branches[k].endJunction.hitTestObject(branches[p].baseJunction)){ 
								  var nodeBase2=getNode(branches[k].endJunction.ids,1);
								  voltageInBase=nodeEnd.voltage-nodeBase2.voltage;
								  trace("volatge calculated");
								  trace("voltageInBase-"+voltageInBase+"----"+nodeBase2.voltage);
								
								}else{
									
								}
								
							}
							trace("voltageInBase-"+voltageInBase);
							if(voltageInBase<0){
								voltageInBase=voltageInBase*-1;
							}
							if(voltageInBase>18){
								trace("inside if="+branches[p].innerComponent);
							
							    Circuit.updateResistance(branches[p].innerComponent.parent.ids,1e-10)
							
								branches[p].innerComponent.resistance=0.0000000001;
							//trace("Object"+branches[k].innerComponent.parent);
							}else if(voltageInBase<18){
								trace("inside esle="+branches[p].innerComponent);
								Circuit.updateResistance(branches[p].innerComponent.parent.ids,100000)
								branches[p].innerComponent.resistance=1000000;
								//trace("Object"+branches[k].innerComponent.parent);
							}
						
				 }
			}
	}*/
		//Call the modified Nodal Analysis Methode
		static public function circuitAlgorithm():void{ 
			var i:int;
			
			numberNodes();
			findAdjacent();
			var dfs:DFS=new DFS();
			
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].offBulbs();
					subCircuits[i].offBatteries();
					SubCircuit.icCurrOut=0;
					SubCircuit.icVoltOut=0;
				}
			}
			subCircuits=dfs.findCircuits();
			//setTransistor();
			for(i=0;i<subCircuits.length;i++){
				if(subCircuits[i].isCycle){
					
						
					subCircuits[i].nodalAnalysis();
					// 
					  
					//trace("fffffffffff:"+subCircuits[i].isChanged)
					if(subCircuits[i].isChanged){
						//var mna1:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);
			          // SubCircuit.getMNA();
					   trace("CALCULATING MANS IN ")
						subCircuits[i].circuitAlgorithm();
					}
				}
				else{
					subCircuits[i].offBulbs();
				}
			}
		}
		static public function circuitAlgorithm1():void{ 
			var i:int;
			
			numberNodes();
			findAdjacent();
			var dfs:DFS=new DFS();
			
			if(subCircuits!=null){
				for(i=0;i<subCircuits.length;i++){
					subCircuits[i].offBulbs();
					subCircuits[i].offBatteries();
					//SubCircuit.icCurrOut=0;
					//SubCircuit.icVoltOut=0;
				}
			}
			subCircuits=dfs.findCircuits();
			//setTransistor();
			for(i=0;i<subCircuits.length;i++){
				if(subCircuits[i].isCycle){
					
					//subCircuits[i].nodalAnalysis1();
					//trace("fffffffffff:"+subCircuits[i].isChanged)
					/*if(subCircuits[i].isChanged){
						
						subCircuits[i].circuitAlgorithm();
					}*/
				}
				else{
					subCircuits[i].offBulbs();
				}
			}
		}
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
		static public function setBulbProperties(branchId:Number,resistance:Number,power:Number,voltage:Number):void{
			circuit.branch.(@index==branchId).@resistance=resistance;
			circuit.branch.(@index==branchId).@powerRating=power;
			circuit.branch.(@index==branchId).@voltageRating=voltage;
		}
		static public function setBatteryVoltage(branchId:Number,voltage:Number):void{
			circuit.branch.(@index==branchId).@voltage=voltage;
		}
		
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