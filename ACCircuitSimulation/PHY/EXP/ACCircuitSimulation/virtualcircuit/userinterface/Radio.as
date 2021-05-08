
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.userinterface{
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.events.MouseEvent;
	import virtualcircuit.logic.Circuit;
	
	public class Radio extends RadioButton{
		static var group:RadioButtonGroup=new RadioButtonGroup("Radio"); //Group name of the radio button
		static var lastValue:String="Lifelike"; //the name of last clicked radio button 
		
		//Constructor
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
		
		//Toggles the view when either of the 2 radio buttons are clicked
		function toggleView(e:MouseEvent){
			if(e.target.value!=lastValue){
				Circuit.toggleGlobalView();
				Circuit.toggleViewForAllBranches();
				lastValue=e.target.value;
			}
		}
		
		//reset the lastValue
		public function resetVal(val:Radio){
			lastValue=val.value;
			val.selected=true;
		}
	}	

}