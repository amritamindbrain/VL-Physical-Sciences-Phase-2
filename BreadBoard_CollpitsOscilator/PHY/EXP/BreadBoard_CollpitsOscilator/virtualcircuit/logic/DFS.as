package virtualcircuit.logic {
	import virtualcircuit.components.Branch;
	
	public class DFS {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var subCircuits:Array;
		var subCircuit:SubCircuit;
		var circuit:XML;
		var positive:Node;
		var flag:Boolean;
		
		public function DFS() {
			this.subCircuits=new Array();
			this.flag=false;
        }
		
		public function findCircuits():Array{
			var i:int;
			var branch:Branch;
			
			if(Circuit.batterCount==0)
				return;
				
			for(i=0;i<Circuit.circuit.battery.length();i++){
				branch=Circuit.getBranch(Circuit.circuit.battery.@branchIndex[i]);
				branch.visited=false;
			}
			
			for(i=0;i<Circuit.circuit.battery.length();i++){
				var count:int=0;
				branch=Circuit.getBranch(Circuit.circuit.battery.@branchIndex[i]);
				if(!branch.visited){
					count++;
					this.subCircuit=new SubCircuit();
					this.subCircuit.ids=count;
					positive=Circuit.getNode(Circuit.circuit.battery.@positive[i],1);
					//trace("positive.predecessor "+positive)
					//if(positive!=null)
						positive.predecessor=null;
					subCircuit.nodes.push(positive);
					this.flag=false;
					getConnectedComponents(positive);
					if(!this.flag)
						subCircuit.isCycle=false;
					subCircuits.push(subCircuit);
				}
			}		
			
			return subCircuits;
		}
		
		function getConnectedComponents(node:Node){
			var nextNode:Node;
					
			for(var j=0;j<node.adj.length;j++){
				nextNode=Circuit.getNode(node.adj[j].circuitIndex,1);
				if(node.predecessor!=nextNode)
					nextNode.predecessor=node;
				if(nextNode==this.positive && node.predecessor!=this.positive){
					this.flag=true;
					subCircuit.isCycle=true;
				}
				var branch:XMLList=Circuit.circuit.branch.((@startJunction==node.circuitIndex && @endJunction==nextNode.circuitIndex) ||(@startJunction==nextNode.circuitIndex && @endJunction==node.circuitIndex) );
				var brn:Branch=Circuit.getBranch(branch.@index);
				if(subCircuit.branches.lastIndexOf(brn)==-1){
					brn.subCircuitIndex=subCircuit.ids;
					subCircuit.branches.push(brn);
					brn.visited=true;
					if(subCircuit.nodes.lastIndexOf(nextNode)==-1){
						subCircuit.nodes.push(nextNode);
						getConnectedComponents(nextNode);
					}
				}														
			}
		}
		
		function printAll(){
			for(var i:int;i<subCircuits.length;i++){
				subCircuits[i].printAll();
			}
		}
		// Public Methods:
		// Protected Methods:
	}
	
}