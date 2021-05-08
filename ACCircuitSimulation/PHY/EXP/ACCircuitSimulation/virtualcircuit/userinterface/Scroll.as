
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.userinterface{
	
	import flash.display.MovieClip;
	import fl.events.SliderEvent;
	import fl.controls.Slider;
	import fl.controls.NumericStepper;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import virtualcircuit.logic.Circuit;
	
	public class Scroll extends MovieClip{
		var slider:Slider; //Slider to change the value
		var labelTxt:TextField;	//TextField to indicate which property of the component is changed
		var numberStepper:NumericStepper;	//Number stepper to input a new value 
		var objt:Object;	//The current selected object of the scroll
		var objArray:Array;	//Array containing all components of same type corresponding to the scroll
		public var isCheckBoxSelected:Boolean;	//Boolean indicating whether the all check box is Selected or not.
		
		//Constructor
		public function Scroll(xPos:Number,yPos:Number,textString:String,min:Number,max:Number,step:Number){
			this.slider=new Slider();
			this.slider.setSize(130,0);
			this.slider.liveDragging=true;
			this.slider.maximum=max;
			this.slider.minimum=min;
			this.slider.snapInterval=step;
			this.slider.move(this.x-60,0);
			this.slider.addEventListener(SliderEvent.CHANGE,getVal);
			this.slider.addEventListener(SliderEvent.THUMB_RELEASE,updateVal);
			
			
			var format:TextFormat = new TextFormat();
			format.size = 15;
			format.bold=true;
			format.align="center";
			
			this.labelTxt=new TextField();
			this.labelTxt.setTextFormat(format);
			this.labelTxt.text=textString;
			this.labelTxt.x=-60;
			this.labelTxt.y=-40;
			this.labelTxt.width=120;
			this.labelTxt.height=35;
			this.labelTxt.selectable=false;
			
			this.numberStepper=new NumericStepper();
			this.numberStepper.x=-30;
			this.numberStepper.y=20;
			this.numberStepper.maximum=max;
			this.numberStepper.minimum=min;
			this.numberStepper.stepSize=step;
			this.numberStepper.addEventListener(Event.CHANGE,changeVal);
			
			this.objArray=new Array();
			this.isCheckBoxSelected=false;
			
			this.x=xPos;
			this.y=yPos;
			this.addChild(this.labelTxt)
			this.addChild(this.numberStepper);
			this.addChild(this.slider);
		}
		
		//gets the valur from NumberStepper
		function getVal(e:SliderEvent):void{
			this.numberStepper.value=e.target.value;
		}
		//updates the value of the property
		function updateVal(e:SliderEvent):void{
			setProperties(this.numberStepper.value);
		}
		//sets the the neww value to corresponding object and also updates the XML
		function setProperties(val:Number):void{
			var resistance:Number;
			
			if(!this.isCheckBoxSelected){
				if(this.objt!=null){
					if(this.objt.parent.type=="ac power" && this.labelTxt.text=="RMS VOLTAGE"){
						this.objt.setVoltage(val);
						Circuit.setBatteryVoltage(this.objt.parent.ids,val);
					}
					else if(this.objt.parent.type=="capacitor"){
						this.objt.setCapacitance(val);
						Circuit.setBranchCapacitance(this.objt.parent.ids,val);
					}
					else if(this.objt.parent.type=="inductor"){
						this.objt.setInductance(val);
						Circuit.setBranchInductance(this.objt.parent.ids,val);
					}
					else{
						this.objt.setResistance(val);
						Circuit.setBranchResistance(this.objt.parent.ids,val);
					}
					for(var j:int=0;j<Circuit.subCircuits.length;j++){
						if(Circuit.subCircuits[j].ids==this.objt.parent.subCircuitIndex){
							Circuit.subCircuits[j].isValueChanged=true;			
							Circuit.subCircuits[j].checkTimer();
						}
					}
					this.objt.parent.setVal(StageBuilder.isShowValues);
					Circuit.circuitAlgorithm();
				}
			}
			else{
				if(this.objArray.length!=0){
					var i:Number;
					if(this.objt.parent.type=="ac power" && this.labelTxt.text=="RMS VOLTAGE"){
						for(i=0;i<this.objArray.length;i++){
							this.objArray[i].setVoltage(val);
							this.objArray[i].parent.setVal(StageBuilder.isShowValues);
							Circuit.setBatteryVoltage(this.objArray[i].parent.ids,val);
						}
					}
					else if(this.objt.parent.type=="ac power" && this.labelTxt.text=="FREQUENCY"){
						for(i=0;i<this.objArray.length;i++){
							this.objArray[i].setFrequency(val);
							this.objArray[i].parent.setVal(StageBuilder.isShowValues);
							Circuit.setBatteryFrequency(this.objArray[i].parent.ids,val);
						}
					}
					else if(this.objt.parent.type=="capacitor"){
						for(i=0;i<this.objArray.length;i++){
							this.objArray[i].setCapacitance(val);
							this.objArray[i].parent.setVal(StageBuilder.isShowValues);
							Circuit.setBranchCapacitance(this.objArray[i].parent.ids,val);
						}
					}
					else if(this.objt.parent.type=="inductor"){
						for(i=0;i<this.objArray.length;i++){
							this.objArray[i].setInductance(val);
							this.objArray[i].parent.setVal(StageBuilder.isShowValues);
							Circuit.setBranchInductance(this.objArray[i].parent.ids,val);
						}
					}
					else{
						for(i=0;i<this.objArray.length;i++){
							this.objArray[i].setResistance(val);
							this.objArray[i].parent.setVal(StageBuilder.isShowValues);
							Circuit.setBranchResistance(this.objArray[i].parent.ids,val);
						}
					}
					for(var k:int=0;k<this.objArray.length;k++){
						for(j=0;j<Circuit.subCircuits.length;j++){
							if(Circuit.subCircuits[j].ids==this.objArray[k].parent.subCircuitIndex){
								Circuit.subCircuits[j].isValueChanged=true;			
								Circuit.subCircuits[j].checkTimer();
							}
						}
					}
					Circuit.circuitAlgorithm();
				}
			}
		}
		//updates the value of property when the value of number stepper is changed
		function changeVal(e:Event):void{
			if(e.target.value>=this.slider.minimum && e.target.value<=this.slider.maximum){
					this.slider.value=e.target.value;
					setProperties(e.target.value);
					this.slider.setFocus();
					this.slider.focusEnabled;
			}			
		}
		//adds objects which are all of same type corresponding to the array
		public function addObject(obj:Object):void{
			this.objArray.push(obj);
		}
		//Scales the TextField to the given value;
		public function ScaleLabel(x:Number,y:Number){
			this.labelTxt.scaleX=x;
			this.labelTxt.scaleY=y;
		}
		
	}	

}