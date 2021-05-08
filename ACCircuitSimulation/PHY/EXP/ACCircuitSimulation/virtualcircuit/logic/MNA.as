/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic {
	
	import virtualcircuit.logic.Node;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.MatrixOps;
	
	public class MNA {
		
		// Constants:
		// Public Properties:
		var circuit:XML;	//XML 
		var matrixA:Array;	//Matrix A of modified nodal analysis containg admittance and other info of nodes in the subcircuit
		var matrixZ:Array;	//Matrix Z of modified nodal analysis containg votages of sources in the subcircuit
		var matrixOpsA:MatrixOps;	//Obj of MatrixOps
		var matrixOpsZ:MatrixOps;	//Obj of MatrixOps
		var batteryCount:int;	//no of batteries in the subcircuit
		var nodeCount:int;	//no of nodes in the subcircuit
		var nodes:Array;	//array containing all nodes in the subcircuit
		var ref:Node;	//the reference node
		var batteries:Array;	//array containing all batteries in the subcircuit
		public var isSingular;	//Boolean indicating if all the matrix is singular(true) or not
		// Private Properties:
		
		//Constructor
		public function MNA(battery:Array,node:Array,refNode:Node,nodeC:int,batteryC:int){
			this.isSingular=false;
			this.circuit=Circuit.circuit;
			this.nodeCount=nodeC;
			this.batteryCount=batteryC;
			this.nodes=node;
			this.ref=refNode;
			this.batteries=battery;
			createA();
			createZ();
			findVoltage();
		}
		//Generates the Matrix A required for nodal Analysis
		function createA():void{
			var node:Node;
			var i:int;
			var j:int;
			var resistance:ComplexNumber;
			var zero:ComplexNumber=new ComplexNumber();
			zero.rectangularForm(0,0);
			var one:ComplexNumber=new ComplexNumber();
			one.rectangularForm(1,0);
			var minusOne:ComplexNumber=new ComplexNumber();
			minusOne.rectangularForm(-1,0);
			
			this.matrixA=createArray(batteryCount+nodeCount);
			
			for(i=0;i<nodes.length;i++){
				for(j=i;j<nodes.length;j++){
					if(i==j){
						this.matrixA[i][j]=zero;
						for(var k=0;k<nodes[i].adj.length;k++){
							admittance=checkIfLCR(nodes[i].circuitIndex,nodes[i].adj[k].circuitIndex);
							if(admittance.getRealPart()!=-1){
								this.matrixA[i][j]=ComplexArithmetic.sum(this.matrixA[i][j],admittance);		
							}
						}
						admittance=checkIfLCR(nodes[i].circuitIndex,ref.circuitIndex);
						if(admittance.getRealPart()!=-1){
							this.matrixA[i][j]=ComplexArithmetic.sum(this.matrixA[i][j],admittance);		
						}
					}
					else{
						node=getNode(j,0);
						if(nodes[i].adj.lastIndexOf(node)!=-1){
							admittance=checkIfLCR(nodes[i].circuitIndex,node.circuitIndex);
							if(admittance.getRealPart()!=-1){
								this.matrixA[i][j]=ComplexArithmetic.subract(this.matrixA[i][j],admittance);
								this.matrixA[j][i]=ComplexArithmetic.subract(this.matrixA[j][i],admittance);
							}
							else{
								this.matrixA[i][j]=zero;
								this.matrixA[j][i]=zero;
							}
						}
						else{
							this.matrixA[i][j]=zero;
							this.matrixA[j][i]=zero;
						}
					}
				}
				
			}
			if(batteryCount!=0){
				
				//Put zeros in all other positions 
				for(i=nodeCount;i<nodeCount+batteryCount;i++){
					for(j=0;j<nodeCount+batteryCount;j++){
						this.matrixA[i][j]=zero;
						this.matrixA[j][i]=zero;
					}
				}
				j=nodeCount;
				for(i=0;i<batteries.length;i++){
					
					var positive:int;
					var negative:int;
					
					positive=circuit.battery.(@branchIndex==batteries[i].ids).@positive;
					negative=circuit.battery.(@branchIndex==batteries[i].ids).@negative;
					
					if(positive!=ref.circuitIndex){
						node=getNode(positive,1);
						this.matrixA[j][node.ids]=one;
						this.matrixA[node.ids][j]=one;
					}
					if(negative!=ref.circuitIndex){
						node=getNode(negative,1);		
						this.matrixA[j][node.ids]=minusOne;
						this.matrixA[node.ids][j]=minusOne;	
					}
					j++;
								
				}				
			}
		}
		//Generates the Matrix Z required for nodal Analysis
		function createZ():void{
			var i:int;
			var voltage:ComplexNumber=new ComplexNumber();
			var zero:ComplexNumber=new ComplexNumber();
			zero.rectangularForm(0,0);
						
			this.matrixZ=createArray(nodeCount+batteryCount);
			for(i=0;i<nodeCount;i++){
				matrixZ[i][0]=zero;
			}
			if(batteryCount!=0){
				var j=0;
				for(i=nodeCount;i<nodeCount+batteryCount;i++){
					voltage.rectangularForm(batteries[j].innerComponent.voltage,0);
					matrixZ[i][0]=voltage;
					j++;
				}
			}
		}
		//Creates a 2 Dimentional array of specified length
		function createArray(len:Number):Array{
			var a:Array=new Array();
			var zero:ComplexNumber=new ComplexNumber();
			zero.rectangularForm(0,0);
			var i:int;
			var j:int;
			
			for(i=0;i<len;i++){
				a[i]=new Array();
			}
			for(i=0;i<len;i++){
				for(j=0;j<len;j++){
					a[i][j]=zero;
				}
			}
			return a;
		}
		//Checks if the component between the 2 nodes is a resistor,inductor or capacitor and returns the admittance
		function checkIfLCR(node1:int,node2:int):ComplexNumber{
			
			var xml:XMLList=circuit.branch.(@startJunction==node1 && @endJunction==node2);
			var freq:Number=batteries[0].innerComponent.frequency;
			var cn:ComplexNumber=new ComplexNumber();
			
			if(xml.length()!=0){
				if(xml.@type=="capacitor"){
					cn.rectangularForm(0,-(2*Math.PI*freq*Number(circuit.branch.(@startJunction==node1 && @endJunction==node2).@capacitance)));
					return cn;
				}
				if(xml.@type=="inductor"){
					cn.rectangularForm(0,(1/(2*Math.PI*freq*Number(circuit.branch.(@startJunction==node1 && @endJunction==node2).@inductance))));
					return cn;
				}
				else{
					cn.rectangularForm((1/(Number(circuit.branch.(@startJunction==node1 && @endJunction==node2).@resistance))),0);
					return cn;
				}
			}
			else{
				var xml1:XMLList=circuit.branch.(@startJunction==node2 && @endJunction==node1);
				if(xml1.length()!=0){
					if(xml1.@type=="capacitor"){
						cn.rectangularForm(0,-(2*Math.PI*freq*Number(circuit.branch.(@startJunction==node2 && @endJunction==node1).@capacitance)));
						return cn;
					}
					if(xml1.@type=="inductor"){
						cn.rectangularForm(0,(1/(2*Math.PI*freq*Number(circuit.branch.(@startJunction==node2 && @endJunction==node1).@inductance))));
						return cn;
					}
					else{
						cn.rectangularForm((1/(Number(circuit.branch.(@startJunction==node2 && @endJunction==node1).@resistance))),0);
						return cn;
					}
				}
			}
			
			cn.rectangularForm(-1,0)
			return cn;
				
		}
		
		//Solves for X using the generated A and Z to get the voltages at each node in the subCircuit
		public function findVoltage():void{
			
			this.matrixOpsA=new MatrixOps(nodeCount+batteryCount,nodeCount+batteryCount);
			this.matrixOpsA.cell=matrixA;
			this.matrixOpsZ=new MatrixOps(nodeCount+batteryCount,1);
			this.matrixOpsZ.cell=matrixZ;
			var matrixOpsX:MatrixOps=new MatrixOps(nodeCount+batteryCount,1);
			var inverse:MatrixOps=this.matrixOpsA.findInverseMatrixUsingLUD();
					
			if(inverse==null){
				this.isSingular=true;
				trace("isSingular",this.isSingular)
				return;
			}
			this.isSingular=false;
			matrixOpsX=inverse.matrixMultiplication(this.matrixOpsZ);
			for(var i=0;i<nodes.length;i++){
				nodes[i].setVoltage(matrixOpsX.cell[i][0]);
			}	
		}	
		//returns the node specified by the id.switchId indicates if the id is node' id in the XML or the 
		//node's Id in the Node Object
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
	}
	
}