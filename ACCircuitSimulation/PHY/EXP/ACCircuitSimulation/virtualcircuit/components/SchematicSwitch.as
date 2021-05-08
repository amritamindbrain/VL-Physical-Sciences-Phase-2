/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.userinterface.StageBuilder;
	
	public class SchematicSwitch extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		var leftBar:SwitchBar;	//Object of SwitchBar
		var middleBar:SwitchBar;	//Object of SwitchBar that closes and opens
		var rightBar:SwitchBar;	//Object of SwitchBar
		var myTween:Tween;	//Tween object to show the clossing and opening of the switch
		var whiteRect:Rect;	//A rectangle whose alpha is 0
		// Initialization:
		public function SchematicSwitch() {
			this.leftBar=new SwitchBar();
			addChild(this.leftBar);
			this.middleBar=new SwitchBar();
			this.middleBar.rotation=-45;
			addChild(this.middleBar);
			this.rightBar=new SwitchBar();
			addChild(this.rightBar);
			this.leftBar.x=this.x-this.leftBar.width-this.middleBar.width/2;
			this.middleBar.x=this.leftBar.x+this.leftBar.width;
			this.rightBar.x=this.middleBar.x+this.middleBar.width;
			this.mouseChildren=false;
			this.doubleClickEnabled=true;
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK,switchClose);
			
			myRadians=Math.atan2(this.middleBar.height,this.middleBar.width);
			myDegree=myRadians*(180/Math.PI);
			
			this.whiteRect=new Rect();
			this.whiteRect.width=this.width;
			this.whiteRect.height=this.height;
			this.whiteRect.x=this.x;
			this.whiteRect.y=this.y;
			this.whiteRect.alpha=0;
			this.addChild(this.whiteRect);
			this.mouseChildren=false;
			this.setChildIndex(this.whiteRect,this.numChildren-4);
		}
	
		// Public Methods:
		//Function shows the closing and opening of switch using tween 
		public function closeTween():void{
			if(!this.parent.isClose){
				if(myTween!=null)
					myTween.stop();
				myTween=new Tween(this.middleBar,"rotation",None.easeOut,-myDegree,0,.1,true);
				myTween.start();
			}
			else{
				if(myTween!=null)
					myTween.stop();
				myTween=new Tween(this.middleBar,"rotation",None.easeOut,0,-myDegree,.1,true);
				myTween.start();		
			}
		}
		
		// Protected Methods:
		//Event Listner captures the double click on the switch button and performs the corresponding action
		function switchClose(e:MouseEvent):void{
			e.target.closeTween();
			e.target.parent.realComponent.closeTween();
			if(!e.target.parent.isClose){
				Circuit.setBranchResistance(this.parent.parent.ids,1e-10)
				this.parent.resistance=1e-10;
				this.parent.isClose=true;
			}
			else{
				Circuit.setBranchResistance(this.parent.parent.ids,10000000000)
				this.parent.resistance=10000000000;
				this.parent.isClose=false;
			}
			if(this.parent.parent.subCircuitIndex!=-1){
				for(var i:int=0;i<Circuit.subCircuits.length;i++){	
					if(Circuit.subCircuits[i].ids==this.parent.parent.subCircuitIndex){
						Circuit.subCircuits[i].isValueChanged=true;			
						Circuit.subCircuits[i].checkTimer();
						break;
					}
				}
			}
			Circuit.circuitAlgorithm();
			StageBuilder.voltmeterObj.updateVoltageReading();
		}
		
		
	}
	
}