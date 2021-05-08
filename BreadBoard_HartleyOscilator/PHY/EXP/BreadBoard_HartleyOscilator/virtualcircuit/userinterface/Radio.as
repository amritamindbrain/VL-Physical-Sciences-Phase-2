package virtualcircuit.userinterface{
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.events.MouseEvent;
	import virtualcircuit.logic.Circuit;
	
	public class Radio extends RadioButton{
		static var group:RadioButtonGroup=new RadioButtonGroup("Radio");
		static var lastValue:String="Lifelike";
		
		public function Radio(l:String,val:String,xPos:Number,yPos:Number){
			this.label=l;
			this.name=l;
			this.group=group;
			this.value=val;
			this.x=xPos;
			this.y=yPos;
			Circuit.setRealView();
			this.addEventListener(MouseEvent.CLICK,toggleView);
		}
		
		function toggleView(e:MouseEvent){
			if(e.target.value!=lastValue){
				Circuit.toggleGlobalView();
				Circuit.toggleViewForAllBranches();
				lastValue=e.target.value;
			}
		}
		
		public function resetVal(val:String){
			lastValue=val;
		}
	}	

}