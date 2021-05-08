
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
	//local
	public class GraphOps {
		var s:Array; //the set of settled vertices, the vertices whose shortest distances from the source have been found 
		var q:Array; //the set of unsettled vertices 
		var subCircuit:SubCircuit;//the Subcircuit in which traversal is performed  
		
		//Implements Dijstra's Algorihtm and finds the shortest distance between 2 nodes src and dest & return the voltage drop across the 2 nodes.
		function traverseGraph(src:Node,dest:Node):Number{
			var u:Node;
			var voltage:Number=0;
			s=new Array(); 
			q=new Array();
			subCircuit=getSubCircuit(src.subCircuitIndex);  
			
			for(var i:int=0;i<subCircuit.nodes.length;i++){
				subCircuit.nodes[i].weight=Infinity;
				subCircuit.nodes[i].predecessor=null;
			}
			q.push(src);
			src.weight=0;
			
			while(q.length!=0){
				u = extract_min(q);
				if(s.lastIndexOf(u)==-1)
				 	s.push(u);
				relax_neighbours(u,s,q);
			}
		}		
		
		//Traverses to the neighbours of node u and updates the weight of the neighbour and push them into q
		function relax_neighbours(u:Node,s:Array,q:Array){
			var i:int;
			
			for(i=0;i<u.adj.length;i++)
			 {
				  var v:Node=u.adj[i];
				  if(s.lastIndexOf(v)==-1){
					  if( v.weight > u.weight + 1 )   // a shorter distance exists
					  {	   
					  	   v.weight = u.weight + 1;
						   v.predecessor = u;
						   if(q.lastIndexOf(v)==-1)
						   		q.push(v);
					  }
				  }
			 }
		}
		//return the node with the smallest weight from q
		function extract_min(q:Array):Node{
			var i:int;
			var min:Number=0;
			var minNode:Node;
			
			for(i=1;i<q.length;i++){
				if(q[min].weight>q[i].weight)
					min=i;
			}
			minNode=q[min];
			q.splice(min,1);
			return minNode;
		}
		//Traverse from the destination to the source and find the RMS voltage
		public function findRMSVoltage(src:Node,node:Node):Number{
			
			traverseGraph(src,node);
			
			var rVoltage:Number=0;
			var cVoltage:Number=0;
			var lVoltage:Number=0;
			var vVoltage:Number=0;
			var voltage:Number=0;
			var temp:Number;
			var xmlbranch:XMLList;
			var branch:Branch;
			
			
			xmlbranch=getXMLBranch(node,src);
			if(xmlbranch.@type=="ac power"){
				branch=getBranch(xmlbranch.@index,subCircuit);
				if(branch.innerComponent.isON){
					temp=branch.innerComponent.rmsVoltage;
					return temp;
				}
				else
					return 0;
			}
			else{
				while(node!=src){
					xmlbranch=getXMLBranch(node,node.predecessor);
					branch=getBranch(xmlbranch.@index,subCircuit);
					temp=branch.rmsVoltage;
					if(xmlbranch.@type=="capacitor"){
						cVoltage+=temp;
					}
					else if(xmlbranch.@type=="inductor"){
						lVoltage+=temp;
					}
					else if(xmlbranch.@type=="ac power "){
						vVoltage+=temp;
					}
					else{
						rVoltage+=temp;
					}
					node=node.predecessor;
				}
				
				voltage=Math.sqrt(Math.pow((lVoltage-cVoltage),2)+Math.pow(vVoltage-rVoltage,2));
				return voltage;
			}
			
		}
		//Traverse from the destination to the source and find the voltage
		public function findVoltage(src:Node,node:Node):Number{
			
			traverseGraph(src,node);
			
			var rVoltage:ComplexNumber=new ComplexNumber();
			var cVoltage:ComplexNumber=new ComplexNumber();
			var lVoltage:ComplexNumber=new ComplexNumber();
			var vVoltage:ComplexNumber=new ComplexNumber();
			var voltage:Number=0;
			var temp:ComplexNumber;
			var xmlbranch:XMLList;
			var branch:Branch;
			
			xmlbranch=getXMLBranch(node,src);
			if(xmlbranch.@type=="ac power"){
				branch=getBranch(xmlbranch.@index,subCircuit);
				if(branch.innerComponent.isON){
					temp=branch.voltageDrop;
					return temp.getRealPart();
				}
				else
					return 0;
			}
			else{
				while(node!=src){
					xmlbranch=getXMLBranch(node,node.predecessor);
					branch=getBranch(xmlbranch.@index,subCircuit);
					temp=branch.voltageDrop;
					if(xmlbranch.@type=="capacitor"){
						cVoltage=ComplexArithmetic.sum(cVoltage,temp);
					}
					else if(xmlbranch.@type=="inductor"){
						lVoltage=ComplexArithmetic.sum(lVoltage,temp);
					}
					else if(xmlbranch.@type=="ac power "){
						vVoltage=ComplexArithmetic.sum(vVoltage,temp);
					}
					else{
						rVoltage=ComplexArithmetic.sum(rVoltage,temp);
					}
					node=node.predecessor;
				}
				var LCvdiff:ComplexNumber=ComplexArithmetic.subract(lVoltage,cVoltage);
				var VRvdiff:ComplexNumber=ComplexArithmetic.subract(vVoltage,rVoltage);
				voltage=Math.sqrt(Math.pow(LCvdiff.getRealPart(),2)+Math.pow(VRvdiff.getRealPart(),2));
				if(VRvdiff.getRealPart()!=0){
					if(VRvdiff.getRealPart()>0)
						return voltage;
					else
						return -voltage;
						
				}
				else{
					if(LCvdiff.getRealPart()>0)
						return voltage;
					else
						return -voltage;
				}
			}
		}
		//returns Obeject of SubCircuit specified by the subId 
		function getSubCircuit(subId:Number):SubCircuit{
			
			for(var i=0;i<Circuit.subCircuits.length;i++){
				if(Circuit.subCircuits[i].ids==subId){
					return Circuit.subCircuits[i];
				}
			}
		}
		//returns Obeject of Branch specified by the branchId 
		function getBranch(branchId:Number,subCircuit:SubCircuit):Branch{
			
			for(var j:int=0;j<subCircuit.branches.length;j++){
				if(subCircuit.branches[j].ids==branchId){
					return subCircuit.branches[j];
				}
			}
				
		}
		//returns XML of the Branch specified by the branchId 
		function getXMLBranch(node1:Node,node2:Node):XMLList{
			var branch:XMLList;
			branch=Circuit.circuit.branch.(@startJunction==node1.circuitIndex&&@endJunction==node2.circuitIndex);
			if(branch.length()!=0){
				return branch;
			}
			branch=Circuit.circuit.branch.(@startJunction==node2.circuitIndex&&@endJunction==node1.circuitIndex);
			return branch;
			
		}
	}
}