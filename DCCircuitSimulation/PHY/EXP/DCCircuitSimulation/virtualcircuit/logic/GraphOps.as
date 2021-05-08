
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
		
		static var circuit:XML;
		 var visited:Array;
		
		public function GraphOps(){
			
			circuit=Circuit.circuit;
		}
		
		public static function updateCircuit():void{
			
			circuit=Circuit.circuit;
		}
		
		public static function getAdjacentBranches(junction:String){
			
			updateCircuit();
			var resultArray:Array=new Array();
			var xmlData=circuit;
			var searchTerm:String=junction;
			var searchData:XMLList=xmlData.branch;
			//trace(searchTerm);
			var searchResults:XMLList = searchData.((hasOwnProperty('@startJunction') && @startJunction.toLowerCase() ==searchTerm)||(hasOwnProperty('@endJunction') && @endJunction.toLowerCase() ==searchTerm));//traces correclty
			//trace(searchResults.length() + " records found");
			if (! searchResults.length()) {
				trace("error");
			} else {
		
			}
			for(var i=0;i<searchResults.length();i++)
			{
				//resultArray.push(sear						//need revision
			}
			return searchResults;
		}
		
		function searchInXML(xmlData:XML, searchTerm:String):XMLList {
			var searchData:XMLList=xmlData.branch;
			//trace(searchTerm);
			var searchResults:XMLList = searchData.(hasOwnProperty('@type') && @type.toLowerCase() ==searchTerm);//traces correclty
			trace(searchResults.length() + " records found");
			if (! searchResults.length()) {
				trace("error");
			} else {
		
			}
		
			return searchResults;
		}
		
		function isVisited(branchIndex:String):Boolean{
			
			//var flag:Boolean=false;
			for(var i=0;i<this.visited.length;i++){
			
				if(visited[i]==branchIndex){
					return true;
				}
			}
			
			return false;
		}
		
		public function markVisited(index:String){
			
			this.visited.push(index);
		}
		
		public static function isBattery(branchIndex:String){
			
			if(xmlData.branch[branchIndex].@type=="battery")
				return true;
			else
				return false;
		}
		
		
		public static function getOppositeJunction(branchIndex:String,junction:String){
			
			updateCircuit();
			var xmlData=circuit;
			var searchTerm:String=junction;
			//var searchResults:XMLList = searchData.((hasOwnProperty('@index') && @startJunction.toLowerCase() ==branchIndex))
			//trace("Opposite junction:"+xmlData.branch[branchIndex].@startJunction);
			if(xmlData.branch[branchIndex].@startJunction==junction){
				
				return xmlData.branch[branchIndex].@endJunction;
			}
			else if(xmlData.branch[branchIndex].@endJunction==junction){
				
				return xmlData.branch[branchIndex].@startJunction;
			}
			else{
				trace("error");
				return null;
			}
			
			//trace(searchTerm);
			//var searchResults:XMLList = searchData.((hasOwnProperty('@startJunction') && @startJunction.toLowerCase() ==searchTerm)||(hasOwnProperty('@endJunction') && @endJunction.toLowerCase() ==searchTerm));//traces correclty
//			trace(searchResults.length() + " records found");
//			if (! searchResults.length()) {
//				trace("error");
//			} else {
//		
//			}
//			
//			return searchResults;
			
		}
		
		//experimental code
		
		public function getVoltage(at:String,target:String,volts:Number){
			
			//var visited:Array=
			
			 if ( at == target ) {
				return volts;
			}
			trace("fine till now 1")
			var out:Array = getAdjacentBranches( at );
			trace("fine till now 2")
			for ( var i = 0; i < out.length; i++ ) {
				var branch:String = out[i];
				var opposite:String = getOppositeJunction( branch,at );
				if ( this.isVisited( branch ) ) {  //don't cross the same bridge twice.
					var dv:Number = 0.0;
					if ( isBattery(branch) ) {				
						
						dv = getVoltageDrop(branch);//climb
					}
					else {
						dv = -getVoltageDrop(branch);//fall
					}
					if ( Circuit.getEndJunction(branch) == opposite ) {		//revise from here
						dv *= 1;
					}
					else {
						dv *= -1;
					}
					//ArrayList copy = new ArrayList( visited );
					trace("Visited: "+branch);
					markVisited(branch );
					var resultVolt:Number = getVoltage( opposite, target, volts + dv );
					if ( (resultVolt<Number.MAX_VALUE) ) {
						return resultVolt;
					}
				}
		}
		
		}
		
	}
}