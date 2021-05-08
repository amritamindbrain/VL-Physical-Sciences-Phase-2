
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.userinterface{
	
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Voltmeter;
	import virtualcircuit.components.NonContactAmmeter;
	
	public class Buttons extends Button{
				
		var stageBuilder:StageBuilder;
		var objt:Object;
		var isShowGraph:Boolean;
		
		//Constructor
		public function Buttons(l:String,xPos:Number,yPos:Number,wd:Number=80,ht:Number=20){
			this.label=l;
			this.x=xPos;
			this.y=yPos;
			this.width=wd;
			this.height=ht;
			this.isShowGraph=false;
			this.addEventListener(MouseEvent.CLICK,action);
		}
		//Performs the action according to the button clicked
		function action(e:MouseEvent):void{
			
			
			 if(e.target.label=="RESET"){
				resetCircuit();
			}
			else if(e.target.label=="DELETE"){
				StageBuilder.deleteComponent();
			}
			else if(e.target.label=="Split Junction"){
				StageBuilder.splitJunction();
			}
			else if(e.target.label=="Show Values"){
				showValues();
			}
			else if(e.target.label=="Graph"){
				showGraph();
			}
		}
		
		//resets the circuit;
		function resetCircuit():void{
			var mainParent=this.parent.parent.parent.parent;
			StageBuilder.resetCircuit();
			stageBuilder=new StageBuilder(mainParent);
			stageBuilder.loadTabComponents();
		}
		//Shows the values of the properties of all the circuit components inside the Area
		function showValues():void{
			if(!StageBuilder.isShowValues){
				StageBuilder.isShowValues=true;				
			}
			else
				StageBuilder.isShowValues=false;
				
			for(var i:int=0;i<Circuit.branches.length;i++){
				if(Circuit.branches[i].insideArea){
					Circuit.branches[i].setVal(StageBuilder.isShowValues);
				}
			}
		}
		//Diplays the graph on the stage
		function showGraph():void{
			if(!this.isShowGraph){
				this.isShowGraph=true;				
				StageBuilder.createGraph();
			}
			else{
				this.isShowGraph=false;
				StageBuilder.removeGraph();
			}
		}
	}	
}