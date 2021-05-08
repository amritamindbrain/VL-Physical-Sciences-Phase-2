/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic {

	public class Node{
		public var ids:int;	//Id of the Node
		public var circuitIndex:int;	//The actual id of the node in the XML
		public var adj:Array;	//Array containing the adjacent nodes 
		public var visit:Number;	//indicates if the node was visited or not (used for graph traversal)
		public var predecessor:Node;	//indicates predecessor of the node (used for graph traversal)
		public var weight:Number;	//indicates weight of the node (used for Dijstra's Algorithm)
		public var voltage:ComplexNumber;	//the voltage of the node
		public var rmsVoltage:Number;	//the Root Mean Square Voltage of the node
		public var isLabelSet:Boolean;	//indicates if a label has been set for the node 
		public var subCircuitIndex:Number;	//the id of the subcircuit to which the node belongs
		
		//Constructor
		public function Node(id,xmlId){
			this.voltage=new ComplexNumber();
			this.rmsVoltage=0;
			this.ids=id;
			this.weight=Infinity;
			this.adj=new Array();
			this.circuitIndex=xmlId;
			this.visit=0;
			this.isLabelSet=false;
			this.subCircuitIndex=-1;
		}
		//sets the voltage of the node
		public function setVoltage(newVoltage:ComplexNumber){
			this.voltage=newVoltage;
			if((newVoltage.getMagnitude()/Math.pow(2,0.5))>this.rmsVoltage){
				this.rmsVoltage=newVoltage.getMagnitude()/Math.pow(2,0.5);
			}
		}	
	}
}