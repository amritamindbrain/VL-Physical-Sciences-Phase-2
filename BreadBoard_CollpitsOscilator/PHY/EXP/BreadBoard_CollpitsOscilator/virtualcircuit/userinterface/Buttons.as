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
				
		public function Buttons(l:String,xPos:Number,yPos:Number){
			this.label=l;
			this.x=xPos;
			this.y=yPos;
			this.width=120;
			this.height=20;
			this.addEventListener(MouseEvent.CLICK,action);
		}
		function action(e:MouseEvent):void{
			
			if(e.target.label=="SAVE"){
				saveCircuit();
			}
			else if(e.target.label=="LOAD"){
				loadCircuit();
			}
			else if(e.target.label=="RESET"){
				resetCircuit();
			}
			else if(e.target.label=="Delete"){
				StageBuilder.deleteComponent();
			}
			else if(e.target.label=="Remove From Board"){
				StageBuilder.removeObjFromBoard();
			}
			else if(e.target.label=="Split Junction"){
				StageBuilder.splitJunction();
			}
			else if(e.target.label=="Show Values"){
				showValues();
			}
		}
		
		function saveCircuit():void{
			trace("save");
		}
		
		function loadCircuit():void{
			trace("load");
		}
		
		function resetCircuit():void{
			var mainParent=this.parent.parent.parent.parent;
			StageBuilder.resetCircuit();
			stageBuilder=new StageBuilder(mainParent);
			stageBuilder.loadTabComponents();
		}
		
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
	}	
}