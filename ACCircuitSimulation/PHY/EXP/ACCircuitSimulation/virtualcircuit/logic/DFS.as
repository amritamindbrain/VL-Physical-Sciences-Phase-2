
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
	
	public class DFS {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var subCircuits:Array; 	//Array contains all the subCircuits 
		var subCircuit:SubCircuit;  //Object of SubCircuit
		var circuit:XML;	//XML representing the circuit
		var positive:Node;	//positive node of a battery
		var negative:Node;	//negative node of a battery
		
		//Constructor
		public function DFS() {
			this.subCircuits=new Array();
        }
		//Finds the subcircuit using a DFS traversal 
		public function findCircuits():Array{
			var i:int;
			var j:int;
			var k:int;
			var branch:Branch;
			var flag:Boolean;
			var count:int=-1;
			
			if(Circuit.batteryCount==0){
				if(Circuit.subCircuits!=null){
					Circuit.oldSubCircuits=Circuit.subCircuits;
				}
				return;
			}
				
			for(i=0;i<Circuit.circuit.battery.length();i++){
				branch=Circuit.getBranch(Circuit.circuit.battery.@branchIndex[i]);
				branch.visited=false;
			}
			
			for(i=0;i<Circuit.circuit.battery.length();i++){
				branch=Circuit.getBranch(Circuit.circuit.battery.@branchIndex[i]);
				if(!branch.visited){
					this.subCircuit=new SubCircuit();
					this.subCircuit.ids=++count;
					positive=Circuit.getNode(Circuit.circuit.battery.@positive[i],1);
					positive.predecessor=null;
					negative=Circuit.getNode(Circuit.circuit.battery.@negative[i],1);
					positive.subCircuitIndex=subCircuit.ids;
					subCircuit.nodes.push(positive);
					getConnectedComponents(positive);	
					subCircuits.push(subCircuit);
				}
			}	
			//findChangedSubCircuits()
			return subCircuits;
		}
		//a recurssive DFS traversal to find if the is a cycle from the positive of a battery to the positive.
		//if it exists then there is a closed circuit and that becomes a subCircuit.
		function getConnectedComponents(node:Node){
			var nextNode:Node;
			
			for(var j=0;j<node.adj.length;j++){
				nextNode=Circuit.getNode(node.adj[j].circuitIndex,1);
				if(node.predecessor!=nextNode)
					nextNode.predecessor=node;
				if(nextNode==this.positive && node.predecessor!=this.positive){
					subCircuit.isCycle=true;
				}
				var branch:XMLList=Circuit.circuit.branch.((@startJunction==node.circuitIndex && @endJunction==nextNode.circuitIndex) ||(@startJunction==nextNode.circuitIndex && @endJunction==node.circuitIndex));
				var brn:Branch=Circuit.getBranch(branch.@index);
				if(subCircuit.branches.lastIndexOf(brn)==-1){
					brn.subCircuitIndex=subCircuit.ids;
					subCircuit.branches.push(brn);
					brn.visited=true;
					if(subCircuit.nodes.lastIndexOf(nextNode)==-1){
						nextNode.subCircuitIndex=subCircuit.ids;
						subCircuit.nodes.push(nextNode);
						getConnectedComponents(nextNode);
					}
				}														
			}
		}
		//finds if any change has been made on each subcircuit
		function findChangedSubCircuits(){
			
			if(Circuit.subCircuits!=null){
				var oldSubCircuits:Array=Circuit.subCircuits; 	 
				
				for(i=0;i<oldSubCircuits.length;i++){
					for(j=0;j<subCircuits.length;j++){
						if(oldSubCircuits[i].branches.length==subCircuits[j].branches.length){
							flag=true;
							for(k=0;k<oldSubCircuits[i].branches.length;k++){
								if(subCircuits[j].branches.lastIndexOf(oldSubCircuits[i].branches[k])==-1){
									flag=false;
									break;
								}
							}
							if(flag){
								if(subCircuits[j].isCycle==oldSubCircuits[i].isCycle && !oldSubCircuits[i].isValueChanged){
									oldSubCircuits[i].isChanged=false;
									subCircuits.splice(j,1);
									subCircuits.push(oldSubCircuits[i]);
								}
								break;
							}
						}
					}
				}
				Circuit.oldSubCircuits=oldSubCircuits;
			}
		}
		//Print all the subCircuits
		function printAll(){
			for(var i:int;i<subCircuits.length;i++){
				subCircuits[i].printAll();
			}
		}
		// Public Methods:
		// Protected Methods:
	}
	
}