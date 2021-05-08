
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
		public static var circuit:XML=<circuit>	</circuit>;
		public static var branches:Array=new Array();
		static var branchCount:Number= 0;
		static var junctionCount:Number=0;
		static var batteryCount:int=0;
		static var nodes:Array=new Array();
		static var viewFlag:Boolean=false;
		public static var subCircuits:Array=new Array();
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
				branch.@resistance=brn.innerComponent.resistance;
				branch.@current=null;
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
			
			//trace(circuit);
			
			xml=circuit.branch.(@startJunction==junction.ids);
			for each(val in xml){
				circuit.branch.(@index==val.@index).@startJunction=val.@prevStartJunction;
			}
			xml=circuit.branch.(@endJunction==junction.ids);
			for each(val in xml){
				circuit.branch.(@index==val.@index).@endJunction=val.@prevEndJunction;
			}
			junction.splitJunctions();
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
				}
			}
			subCircuits=dfs.findCircuits();
			for(i=0;i<subCircuits.length;i++){
				if(subCircuits[i].isCycle){
					subCircuits[i].nodalAnalysis();
					if(subCircuits[i].isChanged){
						subCircuits[i].circuitAlgorithm();
					}
				}
				else{
					subCircuits[i].offBulbs();
				}
			}
		}
		
		static public function setBranchResistance(branchId:Number,resistance:Number):void{
			circuit.branch.(@index==branchId).@resistance=resistance;
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