package virtualcircuit.logic{

	import virtualcircuit.components.Branch;
	import virtualcircuit.components.ICchip;
	import virtualcircuit.components.Comparator;
		import virtualcircuit.userinterface.StageBuilder;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.*;
	import flash.utils.getTimer;
	public class SubCircuit{
		public var ids:int;
		public var branches:Array;
		public var nodes:Array;
		public var isCycle:Boolean;
		public var isChanged:Boolean;
		public var flagDiode:Boolean;
		public var flagcapacitor:Boolean;
		public var flagInductor:Boolean;
		public static var res1=1000;
		public static var res2=1000;
		public static var circuiteOk=Boolean;
		public static var cap1=0.1;
		public static var cap2=0.1;
		public static var inductance1=1;
		public static var inductance2=0;
		public static var  icCurrOut:Number;
		public static  var icVoltOut:Number;
		//var ic:ICchip = new ICchip;
		
		
		//var ic:ICchip=new ICchip;
		
		
		var ref:Node;
		var batteries:Array;
		var resistorCount:int;
		var switchCount:int;
		var ammeterCount:int;
		var bulbCount:int;
		var diodeCount:int;
		var capacitorCount:int;
		var inductorCount:int;
		
		var initialtime;
		var timeRemaining:Number;
		var timer:Timer;
		var capasitorTime=new Array();
		var timeCount=new Array();
		var capasitorArray=new Array();
		var tranArray=new Array();
		var componentArray=new Array();
		var resistorArray=new Array();
		var inductorArray=new Array();
		var batteryArray=new Array();
		var conCapasitorArray=new Array();
		var conTranArray=new Array();
		var conResArray=new Array();
        var tranClosed=new Array();
		 var prvTranBaseVolCalculated=0;
		function SubCircuit(){
			this.ids=-1;
			this.isCycle=false;
			this.flagDiode=true;
			this.flagcapacitor=false;
			this.flagInductor=false;
			this.branches=new Array();
			this.batteries=new Array();
			this.nodes=new Array();
			this.resistorCount=0;
			this.switchCount=0;
			this.ammeterCount=0;
			this.bulbCount=0;
			this.diodeCount=0;
			this.capacitorCount=0;
			this.inductorCount=0;
			timer=new Timer(4);
		    timer.addEventListener(TimerEvent.TIMER,capasitorTiming1);
		}
				
		public function nodalAnalysis():void{
			this.ref=nodes[0];
			this.ref.ids=-1;
			this.ref.voltage=0;
			this.removeRef();
			this.numberNodes();
			getNumberOfBatteries();
			var resCount=0;
			//setLabels();
			var mna3:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
			if(!mna3.isSingular){	
			
			for(var k=0;k<branches.length;k++){
			 if(branches[k].type=="capacitorNew"){
					
					capasitorArray.push(branches[k]);
					branches[k].innerComponent.resistance=100000;
					 trace("capasitance="+branches[k].innerComponent.capValue +"-");
			 }
			  if(branches[k].type=="Transistor"){
					 tranArray.push(branches[k]);
					 branches[k].innerComponent.resistance=100000;
			 }
			  if(branches[k].type!="wire" && branches[k].type!="longWire"){
				componentArray.push(branches[k].type);  
			  }
			   if(branches[k].type=="resistor"){
				   resistorArray.push(branches[k]);
			   }
			    if(branches[k].type=="inductor"){
				   inductorArray.push(branches[k]);
			   } 
			     if(branches[k].type=="battery"){
				   batteryArray.push(branches[k]);
			   } 
			 
			}
			
			var flag:Boolean=circuitAlgorithm();
			
			//trace("nodalAnalysis-"+flag); 
			//trace("array length-"+capasitorArray.length); 
			if(flag){
			//setTransistor();
			if(componentArray.length==13 && resistorArray.length==4 && capasitorArray.length==4 && tranArray.length==1 && inductorArray.length==2 && batteryArray.length==1 ){
				circuiteOk=true;
				setCircuite();
				StageBuilder.disableComponent();
				//trace("conCapasitorArray length-"+conCapasitorArray.length); 
				//trace("conTranArray length-"+conTranArray.length); 
			/*if(timer.running==false){
			
			timer.start();
			trace("timer started");
			}*/
			}else{
				 circuiteOk=false;
				
			      // timer.stop();
			    
			}
			  checkIfBurnBattery();
		   
			}
			}
		 }  
		/*public function nodalAnalysis1():void{
			this.ref=nodes[0];
			this.ref.ids=-1;
			this.ref.voltage=0;
			this.removeRef();
			this.numberNodes();
			getNumberOfBatteries();
			setLabels();
			
			var mna4:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
			if(!mna4.isSingular){	
			
			var flag:Boolean=circuitAlgorithm();
			trace("nodalAnalysis1-"+flag);
			if(flag){
			   if(timer.running==false){
			     //timer.start();
				  trace("nodalAnalysis1 timer started")
			    }
				checkIfBurnBattery();
			}else{
				 
			        timer.stop();
			    
			}
			}
			
		}  */
		
		var capDischargeTime=100;
		var capDischargeTimeCount=0
		public  function capasitorTiming1(e:TimerEvent):void {
			     		initialtime=getTimer();
						timeRemaining=getTimer()-initialtime;
						capDischargeTimeCount++;
						if(capDischargeTimeCount==500){
							trace("first");
							Circuit.updateResistance(branches[conCapasitorArray[0]].innerComponent.parent.ids,1e-10);
							Circuit.updateResistance(branches[conTranArray[1]].innerComponent.parent.ids,1e-10);
							Circuit.updateResistance(branches[conCapasitorArray[1]].innerComponent.parent.ids,100000);
							Circuit.updateResistance(branches[conTranArray[0]].innerComponent.parent.ids,100000);
						    circuitAlgorithm();
						}else if(capDischargeTimeCount==1000){
							trace("second");
							Circuit.updateResistance(branches[conCapasitorArray[1]].innerComponent.parent.ids,1e-10);
							Circuit.updateResistance(branches[conTranArray[0]].innerComponent.parent.ids,1e-10);
							Circuit.updateResistance(branches[conCapasitorArray[0]].innerComponent.parent.ids,100000);
							Circuit.updateResistance(branches[conTranArray[1]].innerComponent.parent.ids,100000);
							capDischargeTimeCount=0;
							circuitAlgorithm();
						}
						
	
		
		}
		/*public  function capasitorTiming1(e:TimerEvent):void {
			     		initialtime=getTimer();
						timeRemaining=getTimer()-initialtime;
						trace("timeRemaining--"+timeRemaining);
						
						for(var l=0;l<capasitorArray.length;l++){
						timeCount[l]=timeCount[l]+1
						Base=Circuit.getNode(branches[p].baseJunction.ids,0);
						var nodeEnd=getNode(branches[p].endJunction.ids,1);
						
						var nod
						if (timeCount[l]==250) {
							/*this.ref=nodes[0];
							this.ref.ids=-1;
							this.ref.voltage=0;
							this.removeRef();
							this.numberNodes();
							getNumberOfBatteries();
							var mna4:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
							if(!mna4.isSingular){	
							initialtime=getTimer();
							trace("INSUDE IF LIGHT BULB--"+branches[capasitorArray[l]].innerComponent)
							Circuit.updateResistance(branches[capasitorArray[l]].innerComponent.parent.ids,1e-10)
							branches[l].innerComponent.resistance=0.0000000001;
							setTransistor();
							Circuit.circuitAlgorithm1();
							//StageBuilder.voltmeterObj.updateVoltageReading();
							///ircuitAlgorithm();
							timeCount[l]=-250;
							//}
						}else if(timeCount[l]==1){
							/*this.ref=nodes[0];
							this.ref.ids=-1;
							this.ref.voltage=0;
							this.removeRef();
							this.numberNodes();
							getNumberOfBatteries();
							var mna5:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
							if(!mna5.isSingular){	
							trace("INSUDE IF OFFBULB"+branches[capasitorArray[l]].innerComponent);
							Circuit.updateResistance(branches[capasitorArray[l]].innerComponent.parent.ids,100000)
							branches[l].innerComponent.resistance=1000000;
							setTransistor();
							Circuit.circuitAlgorithm1();
							// timer.stop();
							//StageBuilder.voltmeterObj.updateVoltageReading();
							//circuitAlgorithm();
							//}
						}
						//
						}
		
		}*/
		/*public  function capasitorTiming(e:TimerEvent):void {
			    var voltageInBase=0;
			    var capIndex=-1;
			    var prvCapIndex=0;
				for(var p=0;p<branches.length;p++){
			     if(branches[p].type=="capacitorNew"){
					 capIndex=p;
				 }
				 if(branches[p].type=="Transistor"){
						var nodeeStart=getNode(branches[p].startJunction.ids,1);
						var nodeEnd=getNode(branches[p].endJunction.ids,1);
						Circuit.updateResistance(branches[p].innerComponent.parent.ids,1e-10)
						branches[p].innerComponent.resistance=0.0000000001;
						 for(var k=0;k<branches.length;k++){
								if(branches[k].startJunction.hitTestObject(branches[p].baseJunction)){
									var nodeBase1=Circuit.getNode(branches[k].startJunction.ids,1);
									//trace("volatge calculated");
									voltageInBase=nodeEnd.voltage-nodeBase1.voltage;
									//trace("voltageInBase-"+voltageInBase+"----"+nodeBase1.voltage);
									 prvTranBaseVolCalculated=voltageInBase;
								}else if(branches[k].endJunction.hitTestObject(branches[p].baseJunction)){ 
								  var nodeBase2=Circuit.getNode(branches[k].endJunction.ids,1);
								  voltageInBase=nodeEnd.voltage-nodeBase2.voltage;
								//  trace("volatge calculated");
								 // trace("voltageInBase-"+voltageInBase+"----"+nodeBase2.voltage);
								  prvTranBaseVolCalculated=voltageInBase;
								}else{
									voltageInBase=prvTranBaseVolCalculated;
								}
								
							}
							if(voltageInBase<0){
								voltageInBase=voltageInBase*-1;
							}
							voltageInBase=Math.round(voltageInBase);
							trace("voltageInBase-"+voltageInBase);
							if(voltageInBase>=18){
								trace("inside if="+branches[p].innerComponent);
							 // 	if(capIndex!=0 || capIndex!=prvCapIndex ){
								if(branches[capIndex].innerComponent.isClosed==false){			
										Circuit.updateResistance(branches[p].innerComponent.parent.ids,1e-10)
							             branches[p].innerComponent.resistance=0.0000000001;
										 Circuit.updateResistance(branches[capIndex].innerComponent.parent.ids,1e-10)
									     branches[capIndex].innerComponent.resistance=0.0000000001;
									     branches[capIndex].innerComponent.isClosed=true;
									     capIndex=prvCapIndex;
								         Circuit.circuitAlgorithm1();
								}
							}else if(voltageInBase<18){
									trace("devi");
								//if(capIndex!=0 || capIndex!=prvCapIndex ){
								if(branches[capIndex].innerComponent.isClosed==true){		
										Circuit.updateResistance(branches[capIndex].innerComponent.parent.ids,100000)
										branches[p].innerComponent.resistance=1000000;
										branches[capIndex].innerComponent.resistance=1000000;
										branches[capIndex].innerComponent.isClosed=false;
										capIndex=prvCapIndex;
										Circuit.circuitAlgorithm1();
								}
								
								
							}
								
				 }
								
							
						
				 
			}  		
		
		}*/
		public static function getMNA(){
			
		
			var mna2:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
			if(!mna2.isSingular){
				//setTransistor();
			}
			
			
			//return mna2;
		}
		
		
		function setCircuite(){
			var voltageInBase=0;
			var capIndex=-1;
			var prvCapIndex=-1;
			var resCount=0;
			var capCount=0;
			var inductorCount=0;
			conCapasitorArray.splice(0, conCapasitorArray.length-1);
			conTranArray.splice(0, conTranArray.length-1)
			for(var p=0;p<branches.length;p++){
				//trace("-"+branches[p].type);
				if(branches[p].type=="resistor"){
					conResArray.push(branches[p]);
				}
				if(branches[p].type=="Transistor"){
					conTranArray.push(branches[p]);
				}
				if(branches[p].type=="capacitorNew"){
					conCapasitorArray.push(branches[p]);
				}
				if(branches[p].type=="inductor"){
					inductorArray.push(branches[p]);
				}
				 if(branches[p].type=="resistor"){
				   resCount++;
				   if(resCount==3){
					   res1= branches[p].innerComponent.resistance;
		  			   
				   }else if(resCount==2){
				     
				      res2= branches[p].innerComponent.resistance;
				   }
				    trace("resistance="+branches[p].innerComponent.resistance +"-"+resCount);
			   }
			    if(branches[p].type=="capacitorNew"){
				   capCount++;
				   if(capCount==1){
					   cap1= branches[p].innerComponent.capValue;
		  			   
				   }
				   trace("capasitance="+branches[p].innerComponent.capValue +"-"+capCount);
			   }
			   if(branches[p].type=="inductor"){
				   inductorCount++;
				   if(inductorCount==1){
					   inductance1= branches[p].innerComponent.inductance;
		  			   
				   }if(inductorCount==2){
					   inductance2= branches[p].innerComponent.inductance;
		  			   
				   }
				   trace("inductance="+branches[p].innerComponent.inductance +"-"+inductorCount);
			   }
			 
			/*if(branches[p].type=="wire"){
				  for(var m=0;m<capasitorArray.length;m++){
					 for(var n=0;n<tranArray.length;n++){
					   /* trace("1-"+branches[p].startJunction.hitTestObject(capasitorArray[m].endJunction));
						 trace("2-"+branches[p].startJunction.hitTestObject(capasitorArray[m].startJunction)); 
						  trace("3-"+branches[p].endJunction.hitTestObject(tranArray[n].baseJunction)); 
						 
						   trace("4-"+branches[p].endJunction.hitTestObject(capasitorArray[m].endJunction));
						 trace("5-"+branches[p].endJunction.hitTestObject(capasitorArray[m].startJunction)); 
						  trace("6-"+branches[p].startJunction.hitTestObject(tranArray[n].baseJunction)); */
						
						
						/*if(((branches[p].startJunction.hitTestObject(capasitorArray[m].endJunction)) ||
							  (branches[p].startJunction.hitTestObject(capasitorArray[m].startJunction)))
							  && (branches[p].endJunction.hitTestObject(tranArray[n].baseJunction))){
										conCapasitorArray.push(capasitorArray[m]);
										conTranArray.push(tranArray[n]);
						   			  
							
												 
							 }else if(((branches[p].endJunction.hitTestObject(capasitorArray[m].endJunction)) ||
							  (branches[p].endJunction.hitTestObject(capasitorArray[m].startJunction)))
							  && (branches[p].startJunction.hitTestObject(tranArray[n].baseJunction))){
										conCapasitorArray.push(capasitorArray[m]);
										conTranArray.push(tranArray[n]);
						    }*/
						 
						 
						 /*if((branches[p].startJunction.hitTestObject(tranArray[n].baseJunction) 
							 && (branches[p].endJunction.hitTestObject(capasitorArray[m].endJunction) || 
							branches[p].endJunction.hitTestObject(capasitorArray[m].startJunction) ))) {
										conCapasitorArray.push(capasitorArray[m]);
										conTranArray.push(tranArray[n]);
												 
							 }else if((branches[p].endJunction.hitTestObject(tranArray[n].baseJunction) 
							 && (branches[p].startJunction.hitTestObject(capasitorArray[m].endJunction) || 
							branches[p].startJunction.hitTestObject(capasitorArray[m].startJunction)))){
										 conCapasitorArray.push(capasitorArray[m]);
										conTranArray.push(tranArray[n]);
																		 
							 }
					  
					  
					  
					  }
				}
			}*/
			
	    }
		//res1=conResArray.resistance;
		//res1=1000;
		//res2=1000;
		trace("conCapasitorArray res "+res1);
		trace("conTranArray------"+conTranArray);
		}
		      
				
			
			
	
		/*function setTransistor(){
		var voltageInBase=0;
		var capIndex=-1;
    	var prvCapIndex=-1;
		for(var p=0;p<branches.length;p++){
			  if(branches[p].type=="capacitorNew"){
					 capIndex=p;
				 }
				 if(branches[p].type=="Transistor"){
						
						var nodeeStart=getNode(branches[p].startJunction.ids,1);
						var nodeEnd=getNode(branches[p].endJunction.ids,1);
						Circuit.updateResistance(branches[p].innerComponent.parent.ids,1e-10)
						
						branches[p].innerComponent.resistance=0.0000000001;
						 for(var k=0;k<branches.length;k++){
								if(branches[k].startJunction.hitTestObject(branches[p].baseJunction)){
									var nodeBase1=Circuit.getNode(branches[k].startJunction.ids,1);
									trace("volatge calculated IF");
									voltageInBase=nodeEnd.voltage-nodeBase1.voltage;
									voltageInBase=nodeBase1.voltage;
									//trace("voltageInBase-"+voltageInBase+"----"+nodeBase1.voltage);
									 prvTranBaseVolCalculated=voltageInBase;
								}else if(branches[k].endJunction.hitTestObject(branches[p].baseJunction)){ 
								  var nodeBase2=Circuit.getNode(branches[k].endJunction.ids,1);
								  voltageInBase=nodeEnd.voltage-nodeBase2.voltage;
								 trace("volatge calculated  ELSE");
								//  trace("voltageInBase-"+voltageInBase+"----"+nodeBase2.voltage);
								 prvTranBaseVolCalculated=voltageInBase;
								}else{
									voltageInBase=prvTranBaseVolCalculated;
								}
								
							}
							
							if(voltageInBase<0){
								voltageInBase=voltageInBase*-1;
							}
							voltageInBase=Math.round(voltageInBase);
							trace("voltageInBase-"+voltageInBase);
							if(voltageInBase>=18){
								trace("inside if="+branches[p].innerComponent);
								//if(capIndex!=-1 || capIndex!=prvCapIndex ){									
									Circuit.updateResistance(branches[p].innerComponent.parent.ids,1e-10)
									branches[p].innerComponent.resistance=0.0000000001;
									branches[capIndex].innerComponent.resistance=0.0000000001;
									branches[capIndex].innerComponent.isClosed=true;
									capIndex=prvCapIndex;
									Circuit.circuitAlgorithm1();
								//}
							}else if(voltageInBase<18){
								//if(capIndex!=-1 || capIndex!=prvCapIndex ){
									trace("inside  else");
									Circuit.updateResistance(branches[p].innerComponent.parent.ids,100000)
								    branches[p].innerComponent.resistance=1000000;
									Circuit.updateResistance(branches[capIndex].innerComponent.parent.ids,100000)
									branches[capIndex].innerComponent.resistance=1000000;
									branches[capIndex].innerComponent.isClosed=false;
									capIndex=prvCapIndex;
								    Circuit.circuitAlgorithm1();
								//}
								
						   }
						
				 }
			}
			
			
	}*/
		function circuitAlgorithm():Boolean{
			//trace("mna  "+batteries,nodes,ref,nodes.length,batteries.length)
			
			
			var mna:MNA=new MNA(batteries,nodes,ref,nodes.length,batteries.length);	
			if(!mna.isSingular){	
				setBranchVoltage();
				//checkIfBurnBattery();
				updateAmmeterReadings();
				return true;
			}
			return false;
		}
		
		
		function removeRef(){
			this.nodes.splice(0,1);
			for(i=0;i<nodes.length;i++){
				var index:int=this.nodes[i].adj.lastIndexOf(ref);
				if(index!=-1){
					this.nodes[i].adj.splice(index,1);
				}				
			}		
		}
		
		function getNumberOfBatteries(){
			var count:int=0;
			
			for(var i:int=0;i<this.branches.length;i++){
				if(this.branches[i].type=="battery"){
					this.batteries.push(this.branches[i]);
					this.branches[i].setCompLabel("V"+String(count++));
				}
			}
		}
		
		function numberNodes():void{
			for(var i:int=0;i<this.nodes.length;i++){
				this.nodes[i].ids=i;
			}
		}
		
		/*function setLabels():void{
			for(var i:int=0;i<branches.length;i++){
				

				if(branches[i].type!= "battery" && branches[i].type!= "wire" && branches[i].type!= "Transistor" && branches[i].type!= "longWire" )
					branches[i].setCompLabel(getCompLabel(branches[i].type));
				if(branches[i].type!= "wire" && branches[i].type!= "Transistor" && branches[i].type!= "longWire"){
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
		}*/
	
		
		function setLabels():void{
			for(var i:int=0;i<branches.length;i++){
				
			
			//if(branches[i].type!= "Transistor" && branches[i].type!= "longWire"){
				
					var startNode=getNode(branches[i].startJunction.ids,1)
					
					if(!startNode.isLabelSet){if(branches[i].type!= "battery" && branches[i].type!= "wire" && branches[i].type!= "Transistor" && branches[i].type!= "longWire" ){
						branches[i].setCompLabel(getCompLabel(branches[i].type));
					}
				if(branches[i].type!= "wire" && branches[i].type!= "Transistor" && branches[i].type!= "longWire"){
						branches[i].setStartJnLabel(String(startNode.ids+1));
						startNode.isLabelSet=true;					
					
					var endNode=getNode(branches[i].endJunction.ids,1)
					if(!endNode.isLabelSet){
						branches[i].setEndJnLabel(String(endNode.ids+1));
						endNode.isLabelSet=true;					
					}
					
				}
			}
			}
		}
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
			}else if(type=="diode"){
				return "D"+String(diodeCount++);
			}/*else if(type=="capacitor"){
				return "C"+String(capacitorCount++);
			}*/else if(type=="inductor"){
				return "I"+String(inductorCount++);
			}
		}
		function setBranchVoltage():void{
			var voltage:Number;
			var current:Number;
			var bulbindex;
			var k=2;
			var impedence:ComplexNumber=new ComplexNumber();
			var f=0;
			//trace("  inside  setBranchVoltage   ")
	        var isTranClosed:Boolean;
			isTranClosed=true;
				var voltageInBase=0;
			
			for(var i=0;i<branches.length;i++){
				//trace(branches[i]+"--"+branches[i].ids+",")
				//trace("inside lopp");
				var branch:XMLList=Circuit.circuit.branch.(@index==branches[i].ids);
				
				trace("branches[i].resistance="+branches[i].innerComponent.resistance+"=type="+branches[i].type);
				var node1=getNode(branch.@startJunction,1);
				var node2=getNode(branch.@endJunction,1);
				//trace(branch.@type+":"+branch.@startJunction+":"+branch.@endJunction)
				/*if(branch.@type=="diode"){
					var prevNeighbour:XMLList=Circuit.circuit.branch.(@index==branches[i-1].ids);
					if(Number(prevNeighbour.@startJunction)==Number(branch.@startJunction) || Number(prevNeighbour.@endJunction)==Number(branch.@startJunction)){
						flagDiode=false	
					}				
				}*/
				/*if(branches[i].type=="comparator"){
					var nodeComp:Node;
					nodeComp = getNode(branches[i].startJunction.ids,1);
					var nodeCompVolt = nodeComp.voltage;
					//nodeCompVolt=Number(nodeComp.voltage*Math.pow(10,11))
					nodeCompVolt=nodeCompVolt.toPrecision(2);
					if(nodeCompVolt < 0){
						nodeCompVolt = -nodeCompVolt;
					}
					//trace("comparator "+nodeCompVolt)
					var comp:Comparator=new Comparator;
					if(nodeCompVolt<comp.referenceVoltage){
						
						
					}
				}*/
				//trace(node1.voltage+":nodevoltage:"+node2.voltage)
				//trace(node1.inductance+":inductance:"+node2.inductance)
				
				if (node1==null ||node2 ==null){
					trace("devi");
					break;
				}
				trace("node1.voltage="+node1.voltage+"-node2.voltage-"+node2.voltage);
				if(node1.voltage>=node2.voltage){
					voltage=Utilities.roundDecimal(node1.voltage-node2.voltage,2);
					
					/*if(branches[i].type=="capacitor" && (!flagInductor)){
						flagcapacitor=true
					current=Utilities.roundDecimal((node1.voltage-node2.voltage)* 2 * 3.14* f* branches[i].innerComponent.capacitance,2);		
					} else*/ 
					/*if(branches[i].type=="inductor"){	
						
						current=Utilities.roundDecimal((node1.voltage-node2.voltage)/0,2);
						if((voltage==0.02) && (current==Infinity))
						{
							flagInductor=true;
							//flagcapacitor=false;
							
						}

						//current=Utilities.roundDecimal((node1.voltage-node2.voltage)/2 * 3.14* f* branches[i].innerComponent.inductance,2);
					}
					else{*/
						current=Utilities.roundDecimal((node1.voltage-node2.voltage)/branches[i].innerComponent.resistance,2);
					//}
					branches[i].setVoltageDrop(voltage);
					branches[i].setCurrent(current);
					Circuit.circuit.branch.(@index==branch.@index).@voltage=voltage;
					Circuit.circuit.branch.(@index==branch.@index).@current=current;
					Circuit.circuit.branch.(@index==branch.@index).@currentStart=node1.circuitIndex;
					Circuit.circuit.branch.(@index==branch.@index).@currentEnd=node2.circuitIndex;					
					/*if(!flagDiode){
						current=0
						voltage=0	
						if(bulbindex!=undefined){
							trace("bulb off");
							bulbindex.innerComponent.glowBulb(voltage);
						}
					}*/
					/*if(flagcapacitor){
										
							if(bulbindex!=undefined){
								trace("bulb off");
								bulbindex.innerComponent.glowBulb(0);
							}
					}*/
					
					//trace("voltage1:"+voltage+", current1:"+current)
					
					if(branches[i].type=="CROinputTerminal"){	
					     var node5=getNode(branches[i].startJunction.ids,1);
						var node6=getNode(branches[i].endJunction.ids,1);
						trace("node5.voltage="+node5.voltage+"-node6.voltage-"+node6.voltage);
						if(node5.voltage>=node6.voltage){
					        icVoltOut=Utilities.roundDecimal(node5.voltage-node6.voltage,2);
						}else if(node6.voltage>node5.voltage){
							icVoltOut=Utilities.roundDecimal(node6.voltage-node5.voltage,2);
						}
						//trace("CROinputTerminal voltage="+icVoltOut);
					}
					if(branches[i].type=="bulb"){	
					//trace("bulbvoltage1:"+voltage)
					bulbindex=branches[i];
					branches[i].innerComponent.glowBulb(voltage);
					icCurrOut=current;
				   // icVoltOut=voltage;
					}
				}
				else if(node2.voltage>node1.voltage){
					voltage=Utilities.roundDecimal(node2.voltage-node1.voltage,2);
					/*if(branches[i].type=="capacitor"){
						flagcapacitor=true
						
						current=Utilities.roundDecimal((node2.voltage-node1.voltage)* 2 * 3.14* f* branches[i].innerComponent.capacitance,2);
					}else*/ /*if(branches[i].type=="inductor")
					{
						//current=Utilities.roundDecimal((node2.voltage-node1.voltage)/2 * 3.14* f* branches[i].innerComponent.inductance,2);
						current=Utilities.roundDecimal((node2.voltage-node1.voltage)/0,2);
						
					}*/
					//else{
					current=Utilities.roundDecimal((node2.voltage-node1.voltage)/branches[i].innerComponent.resistance,2);
					//}
					Circuit.circuit.branch.(@index==branch.@index).@voltage=voltage;
					Circuit.circuit.branch.(@index==branch.@index).@current=current;
					Circuit.circuit.branch.(@index==branch.@index).@currentStart=node2.circuitIndex;
					Circuit.circuit.branch.(@index==branch.@index).@currentEnd=node1.circuitIndex;
					/*if(!flagDiode){
						current=0
						voltage=0	
						if(bulbindex!=undefined){
							bulbindex.innerComponent.glowBulb(voltage);
						}
					}
					if(flagcapacitor){
											
							if(bulbindex!=undefined){
								bulbindex.innerComponent.glowBulb(0);
							}
					}*/
					//trace("voltage2:"+voltage+", current2:"+current)
					
					
					if(branches[i].type=="bulb"){
						//trace("bulbvoltage2:"+voltage)
						trace("bulb off");
						bulbindex=branches[i];
						branches[i].innerComponent.glowBulb(voltage);
						icCurrOut=current;
				   // icVoltOut=voltage;
					}
				}
				/*if(voltage!=0){
					icCurrOut=current;
				    icVoltOut=voltage;
					}
					else{
						icCurrOut=0;
				    icVoltOut=0;
					}*/
				//trace("voltage: "+voltage+", current: "+current)
				
				//trace("sub circuit "+icCurrOut,icVoltOut)
				//trace(branch.@type)
				//ic.test(icCurrOut,icVoltOut);
				
			//}
			}
		
			for(var d=0;d<branches.length;d++){
				
				 	if(branches[d].type=="CROinputTerminal"){	
					     var node7=getNode(branches[d].startJunction.ids,1);
						var node8=getNode(branches[d].endJunction.ids,1);
						trace("node7.voltage="+node7.voltage+"-node8.voltage-"+node8.voltage);
						if(node7.voltage>=node8.voltage){
					        icVoltOut=Utilities.roundDecimal(node7.voltage-node8.voltage,2);
						}else if(node8.voltage>node7.voltage){
							icVoltOut=Utilities.roundDecimal(node8.voltage-node7.voltage,2);
						}
					}
				
				}
				ICchip.test(icVoltOut,icCurrOut);
				
				trace("voltage----"+icVoltOut);
		}
		function checkIfBurnBattery(){
			var  neighbours:XMLList;
			var  neighbour:XML;
			this.isChanged=false;
			
			for(i=0;i<batteries.length;i++){
				trace("battery connected");
				var flag=false;
				var battery:XMLList=Circuit.circuit.branch.(@index==batteries[i].ids);
				neighbours=Circuit.circuit.branch.((@startJunction==battery.@startJunction || @endJunction==battery.@startJunction) && @index!=battery.@index);
				for each(neighbour in neighbours){
					if(neighbour.@current>Circuit.MAX_CURRENT){
						//trace("flagDiode::"+flagDiode);
						if(flagDiode){
						if(batteries[i].innerComponent.setFire())
						this.isChanged=true;					
						flag=true;
						break;
						}
					}	
				}
				if(!flag){
					if(batteries[i].innerComponent.offFire())
						this.isChanged=true;										
				}
			}
		}		
		function updateAmmeterReadings(){
			
			for(var i=0;i<this.branches.length;i++)
			{				
				if(branches[i].type=="ammeter"){
					
					branches[i].innerComponent.updateCurrentReading();
				}
			}
		}
		
		public function offBulbs(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="bulb"){
					branches[i].innerComponent.glowBulb(0);
				}
			}
		}
		public function offBatteries(){
			for(var i:int=0;i<branches.length;i++){
				if(branches[i].type=="battery"){
					branches[i].innerComponent.offFire();
				}
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
		
		function getBranch(branchId:Number):Branch{
			
			for(var i=0;i<branches.length;i++){
				if(branches[i].ids==branchId){
					return branches[i];
				}
			}
		}
		
		public function printAll(){
			var i:int;
			trace("nodes");
			for(i=0;i<nodes.length;i++){
				nodes[i].printAll();
			}		
		}
	}
}