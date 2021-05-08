/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic{

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import virtualcircuit.components.Branch;
	import virtualcircuit.userinterface.StageBuilder;
	
	public class SubCircuit{
		public var ids:int;
		public var branches:Array;
		public var nodes:Array;
		public var isCycle:Boolean;
		public var isChanged:Boolean;
		public var isValueChanged:Boolean;
		var ref:Node;
		var batteries:Array;
		var acSources:Array;
		var resistorCount:int;
		var switchCount:int;
		var ammeterCount:int;
		var bulbCount:int;
		var capacitorCount:int;
		var inductorCount:int;
		var batteryCount:int;
		var t:Number;
		var interval:Number;
		var timer:Timer;
		
		//Constructor
		function SubCircuit(){
			this.ids=-1;
			this.isCycle=false;
			this.isChanged=true;
			this.isValueChanged=false;
			this.branches=new Array();
			this.batteries=new Array();
			this.acSources=new Array();
			this.nodes=new Array();
			this.resistorCount=0;
			this.switchCount=0;
			this.ammeterCount=0;
			this.bulbCount=0;
			this.capacitorCount=0;
			this.inductorCount=0;
			this.batteryCount=0;
			this.interval=10;
			this.t=0;
			resetRMS();
			this.timer=new Timer(interval);
			this.timer.addEventListener(TimerEvent.TIMER,continuousEvent);
		}
		
		//Setups the subCircuit for modified nodal analysis
		public function nodalAnalysis():void{
			this.ref=nodes[0];
			this.ref.ids=-1;
			this.ref.voltage.rectangularForm(0,0);
			this.removeRef();
			this.numberNodes();
			setLabels();
			resetRMS();
			this.timer.start();			
		}
		
		//Checks if a timer is already runnning for the subcircuit if yes stop
		public function checkTimer(){
			if(this.timer.running){
				this.timer.stop();
				resetRMS();
			}
		}
		//Checks if a timer is already runnning for the subcircuit if no start
		public function startTimer(){
			if(!this.timer.running){
				this.timer.start();
			}
		}
		//Calls the algorithm for each interval of the timer event
		function continuousEvent(e:TimerEvent){
			for(var i:int=0;i<acSources.length;i++){
				acSources[i].innerComponent.sinVoltage(t);
			}
			t=t+(interval/100000);
			circuitAlgorithm();
		}
		//calls the Modified Nodal Analysis function
		public function circuitAlgorithm(){
			var mna:MNA=new MNA(acSources,nodes,ref,nodes.length,acSources.length);
			if(!mna.isSingular){
				setBranchVoltage();
				checkIfBurnBattery();
				updateAmmeterReadings();
			}
		}
		//removes the reference node from the node array
		function removeRef(){
			this.nodes.splice(0,1);
			for(i=0;i<nodes.length;i++){
				var index:int=this.nodes[i].adj.lastIndexOf(ref);
				if(index!=-1){
					this.nodes[i].adj.splice(index,1);
				}				
			}		
		}
		//returns the number of AC Sources in the subCircuit
		public function getNumberOfACSources(){
			for(var i:int=0;i<this.branches.length;i++){
				if(this.branches[i].type=="ac power"){
					this.acSources.push(this.branches[i]);
				}
			}
		}
		//returns the number of nodes in the subCircuit
		function numberNodes():void{
			for(var i:int=0;i<this.nodes.length;i++){
				this.nodes[i].ids=i;
			}
		}
		//set labels for each component
		function setLabels():void{
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type!= "wire" ){
					branches[i].setCompLabel(getCompLabel(branches[i].type));
					var startNode=getNode(branches[i].startJunction.ids,1)
					if(!startNode.isLabelSet){
						branches[i].setStartJnLabel(String(startNode.ids+1));
						startNode.isLabelSet=true;					
					}
					var endNode=getNode(branches[i].endJunction.ids,1)
					if(!endNode.isLabelSet){
						branches[i].setEndJnLabel(String(endNode.ids+1));
						endNode.isLabelSet=true;					
					}
				}
			}
		}
		//return the value for the label according to the type of the component
		function getCompLabel(type:String):String{
			
			if(type=="resistor"){
				return "R"+String(resistorCount++);
			}	
			else if(type=="bulb"){
				return "B"+String(bulbCount++);
			}	
			else if(type=="switch"){
				return "S"+String(switchCount++);
			}				
			else if(type=="ammeter"){
				return "A"+String(ammeterCount++);
			}	
			else if(type=="capacitor"){
				return "C"+String(capacitorCount++);
			}	
			else if(type=="inductor"){
				return "I"+String(inductorCount++);
			}
			else if(type=="battery" || type=="ac power"){
				return "V"+String(batteryCount++);
			}
		}
		//resets the rms values of all the branches before starting the algorithm
		function resetRMS(){
			for(var i:int=0;i<branches.length;i++){
				branches[i].resetRMS();
			}
		}
		//sets the voltage and current across each branch in the circuit
		function setBranchVoltage():void{
			var voltage:ComplexNumber=new ComplexNumber();
			var current:ComplexNumber=new ComplexNumber();
			var impedence:ComplexNumber=new ComplexNumber();
			var frequency:Number=acSources[0].innerComponent.frequency; 
			var omega:Number=2*Math.PI*frequency; 
			var pCurr:Number;
			var curr:Number;
			
			for(var i=0;i<branches.length;i++){
				var branch:XMLList=Circuit.circuit.branch.(@index==branches[i].ids);
				var node1=getNode(branch.@startJunction,1);
				var node2=getNode(branch.@endJunction,1);
				if(branch.@type=="capacitor"){
					impedence.rectangularForm(0,(-1/(2*Math.PI*frequency*branch.@capacitance)));	
				}
				else if(branch.@type=="inductor"){
					impedence.rectangularForm(0,(2*Math.PI*frequency*branch.@inductance));
				}
				else{
					impedence.rectangularForm(branch.@resistance,0);
				}
				voltage=ComplexArithmetic.subract(node1.voltage,node2.voltage);
				current=ComplexArithmetic.divide(voltage,impedence);
				var rVoltage:ComplexNumber=Utilities.roundComplexNumber(voltage,2);
				var rCurrent:ComplexNumber=Utilities.roundComplexNumber(current,2);
				branches[i].setVoltageDrop(rVoltage);
				branches[i].setCurrent(rCurrent);
				if(branches[i].type=="capacitor" || branches[i].type=="inductor"){
					pCurr=(branches[i].rmsVoltage*Math.pow(2,.5))/impedence.getMagnitude();
					if(branches[i].type=="capacitor"){
						curr=pCurr*Math.sin(Utilities.roundDecimal(omega*t)+(Math.PI/2));
					}
					else
						curr=pCurr*Math.sin(Utilities.roundDecimal(omega*t)-(Math.PI/2));
					branches[i].setPhaseCurrent(curr);
				}else if(branches[i].type=="bulb"){
					branches[i].innerComponent.glowBulb(voltage.getMagnitude());
				}
			}
		}
		//Checks if the large current is flowing through the battery
		function checkIfBurnBattery(){
			var  neighbours:XMLList;
			var  neighbour:XML;
			
			for(i=0;i<acSources.length;i++){
				var flag=false;
				var battery:XMLList=Circuit.circuit.branch.(@index==acSources[i].ids);
				neighbours=Circuit.circuit.branch.((@startJunction==battery.@startJunction || @endJunction==battery.@startJunction) && @index!=battery.@index);
				for each(neighbour in neighbours){
					for(var j:int=0;j<this.branches.length;j++){	
						if(neighbour.@index==branches[j].ids){
							if(branches[j].rmsCurrent>Circuit.MAX_CURRENT){
								acSources[i].innerComponent.setFire();
								flag=true;
							}
							break;
						}
						if(flag)
							break;
					}
				}
				if(!flag){
					acSources[i].innerComponent.offFire();
				}
			}	
		}	
		//updates the readings of the ammeters and voltmeter in the subcircuit
		function updateAmmeterReadings(){
			
			for(var i=0;i<this.branches.length;i++)
			{				
				if(branches[i].type=="ammeter"){
					if(!branches[i].isIRMSReached)
						branches[i].innerComponent.updateCurrentReading();
				}
			}
			for(var j:int=0;j<branches.length;j++){
				if(branches[j].type!="wire")
					break;
			}
			if(StageBuilder.voltmeterObj!=null && StageBuilder.voltmeterObj.volt.insideArea){	
				if(!branches[j].isVRMSReached)
					StageBuilder.voltmeterObj.updateVoltageReading();
			}
		}
		//offs the fire of the battery if it is burning
		public function offBatteries(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="ac power"){
					branches[i].innerComponent.offFire();
				}
			}
		}
		//offs the bulb if it is ON
		public function offBulbs(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="bulb"){
					branches[i].innerComponent.glowBulb(0);
				}
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
		//returns the Object of Branch specified by branchId
		function getBranch(branchId:Number):Branch{
			
			for(var i=0;i<branches.length;i++){
				if(branches[i].ids==branchId){
					return branches[i];
				}
			}
		}
	}
}