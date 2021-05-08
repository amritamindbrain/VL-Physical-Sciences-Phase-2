
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
		public var ids:int;
		public var circuitIndex:int;
		public var adj:Array;
		public var visit:Number;
		public var predecessor:Node;
		public var voltage:Number;
		public var isLabelSet:Boolean;
		
		public function Node(id,xmlId){
			this.ids=id;
			this.adj=new Array();
			this.circuitIndex=xmlId;
			this.visit=0;
			this.isLabelSet=false;
		}
		
		public function printAll(){
			trace("new",this.ids," old",this.circuitIndex,"voltage:",this.voltage,"visit:",this.visit,"length:",adj.length);
		}
		
		public function printAdj(){
			for(var k=0;k<adj.length;k++){
				trace("circuitIndex",this.adj[k].circuitIndex,"ids",this.adj[k].ids);
			}
			//trace(adj.length,adj);
		}		
	}
}