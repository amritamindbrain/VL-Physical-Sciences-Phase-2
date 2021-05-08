package virtualcircuit.logic {
	
	import virtualcircuit.logic.Node;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.MatrixOps;
	
	public class MNA {
		
		// Constants:
		// Public Properties:
		var circuit:XML;
		var matrixA:Array;
		var matrixZ:Array;
		var matrixOpsA:MatrixOps;
		var matrixOpsZ:MatrixOps;
		var batteryCount:int;
		var nodeCount:int;
		var nodes:Array;
		var ref:Node;
		var batteries:Array;
		public var isSingular;
		// Private Properties:
		
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
				
		function createA():void{
			var node:Node;
			var i:int;
			var j:int;
			var admittance:Number;
			
			this.matrixA=createArray(batteryCount+nodeCount);
			
			for(i=0;i<nodes.length;i++){
				for(j=i;j<nodes.length;j++){
					if(i==j){
						this.matrixA[i][j]=0;
						for(var k=0;k<nodes[i].adj.length;k++){
							admittance=checkIfLCR(nodes[i].circuitIndex,nodes[i].adj[k].circuitIndex);
							//trace(nodes[i].circuitIndex+"::"+nodes[i].adj[k].circuitIndex)
							//trace("1st",admittance);
							if(admittance!=-1){
								this.matrixA[i][j]+=(1/admittance);		
							}
						}
						admittance=checkIfLCR(nodes[i].circuitIndex,ref.circuitIndex);
						//trace("2nd",admittance,nodes[i].circuitIndex,ref.circuitIndex);
						if(admittance!=-1){
							this.matrixA[i][j]+=(1/admittance);		
						}
						//trace(i,j);
					}
					else{
						node=getNode(j,0);
						if(nodes[i].adj.lastIndexOf(node)!=-1){
							admittance=checkIfLCR(nodes[i].circuitIndex,node.circuitIndex);
							//trace("3rd",admittance);
							if(admittance!=-1){
								//trace(i,j);
								this.matrixA[i][j]=-(1/admittance);
								this.matrixA[j][i]=-(1/admittance);
							}
							else{
								//trace(i,j);
								this.matrixA[i][j]=0;
								this.matrixA[j][i]=0;
							}
						}
						else{
							//trace(i,j);
							this.matrixA[i][j]=0;
							this.matrixA[j][i]=0;
						}
					}
				}
				
			}
			//trace(matrixA);
			if(batteryCount!=0){
				
				//Put zeros in all other positions 
				for(i=nodeCount;i<nodeCount+batteryCount;i++){
					for(j=0;j<nodeCount+batteryCount;j++){
						this.matrixA[i][j]=0;
						this.matrixA[j][i]=0;
					}
				}
				j=nodeCount;
				for(i=0;i<batteries.length;i++){
					var positive:int;
					var negative:int;
					
					positive=circuit.battery.(@branchIndex==batteries[i].ids).@positive;
					negative=circuit.battery.(@branchIndex==batteries[i].ids).@negative;
					//trace("positive:"+positive);
					//trace("negative"+negative);
						
					if(positive!=ref.circuitIndex){
						node=getNode(positive,1);
						this.matrixA[j][node.ids]=1;
						this.matrixA[node.ids][j]=1;
					}
					if(negative!=ref.circuitIndex){
						node=getNode(negative,1);		//change
						if(node==null){	//ADDED
							node=new Node(0,0);	//ADDED
							node.ids = 0;	//ADDED
						}	//ADDED
						this.matrixA[j][node.ids]=-1;
						this.matrixA[node.ids][j]=-1;
							
						
						//trace("mna.........  "+node.ids,this.matrixA[j][node.ids])//,this.matrixA[j][node.ids]
					}
					j++;	
								
				}			
			}
			//trace(matrixA);
		}
				
		function createZ():void{
			var i:int;
			this.matrixZ=createArray(nodeCount+batteryCount);
			for(i=0;i<nodeCount;i++){
				matrixZ[i][0]=0;
			}
			if(batteryCount!=0){
				var j=0;
				for(i=nodeCount;i<nodeCount+batteryCount;i++){
					matrixZ[i][0]=circuit.branch.(@index==batteries[j].ids).@voltage;
					j++;
				}
			}
			//trace(matrixZ);
		}
		
		function createArray(len:Number):Array{
			var a:Array=new Array();
			for(var i=0;i<len;i++){
				a[i]=new Array();
			}
			return a;
		}
		
		/*function checkIfResistor(node1:int,node2:int):Number{
			
			if(circuit.branch.(@startJunction==node1 && @endJunction==node2).length()!=0){
			return circuit.branch.(@startJunction==node1 && @endJunction==node2).@resistance;
				
			}
			else if(circuit.branch.(@startJunction==node2 && @endJunction==node1).length()!=0){
				return circuit.branch.(@startJunction==node2 && @endJunction==node1).@resistance;
			}
			return -1;
		}*/
		function checkIfLCR(node1:int,node2:int):Number{
			
			var xml:XMLList=circuit.branch.(@startJunction==node1 && @endJunction==node2);
			
			
			if(xml.length()!=0){
				if(xml.@type=="capacitor"){
					return circuit.branch.(@startJunction==node1 && @endJunction==node2).@capacitance;
					
				}
				/*if(xml.@type=="inductor"){
					//trace("FFFFF"+circuit.branch.(@startJunction==node1 && @endJunction==node2).@inductance)
					return circuit.branch.(@startJunction==node1 && @endJunction==node2).@inductance;
					
				}*/
				else{
					//trace("FFFFFrrr"+circuit.branch.(@startJunction==node1 && @endJunction==node2).@resistance)
					return circuit.branch.(@startJunction==node1 && @endJunction==node2).@resistance;
					
				}
			}
			else{
				var xml1:XMLList=circuit.branch.(@startJunction==node2 && @endJunction==node1);
				if(xml1.length()!=0){
					if(xml1.@type=="capacitor"){
						return circuit.branch.(@startJunction==node2 && @endJunction==node1).@capacitance;
					}
					/*if(xml1.@type=="inductor"){
						//trace("IIIIIIIII:"+circuit.branch.(@startJunction==node2 && @endJunction==node1).@inductance)
						return circuit.branch.(@startJunction==node2 && @endJunction==node1).@inductance;
					}*/
					else{
						//trace("IIIIIIIIIrrrr:"+circuit.branch.(@startJunction==node2 && @endJunction==node1).@resistance)
						return circuit.branch.(@startJunction==node2 && @endJunction==node1).@resistance;
					}
				}
			}
			
			return -1;
				
		}
		
		public function findVoltage():void{
			
			this.matrixOpsA=new MatrixOps(nodeCount+batteryCount,nodeCount+batteryCount);
			this.matrixOpsA.cell=matrixA;
			//this.matrixOpsA.printMatrix(this.matrixOpsA);
			this.matrixOpsZ=new MatrixOps(nodeCount+batteryCount,1);
			this.matrixOpsZ.cell=matrixZ;
			var matrixOpsX:MatrixOps=new MatrixOps(nodeCount+batteryCount,1);
			var inverse:MatrixOps=this.matrixOpsA.findInverseMatrixUsingLUD();
			
			if(inverse==null){
				this.isSingular=true;
				return;
			}
			this.isSingular=false;
			matrixOpsX=inverse.matrixMultiplication(this.matrixOpsZ);
			for(var i=0;i<nodes.length;i++){
				nodes[i].voltage=matrixOpsX.cell[i];
				//nodes[i].printAll();
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
		// Public Methods:
		// Protected Methods:
	}
	
}