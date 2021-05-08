
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
	
	public class RealSwitch extends MovieClip{
		
		// Constants:
		// Public Properties:
		
		// Private Properties:
		var prevWidth:Number;
		public var switchButtonObj:SwitchButton;
		var woodObj:Wood;
		static var ckt:Circuit=new Circuit();
		var iron1:Iron;
		var iron2:Iron;
		static var myRadians:Number;
		static var myDegree:Number;
		var myTween:Tween;
		// Initialization:
		public function RealSwitch() { 
			this.woodObj=new Wood();
			this.woodObj.x=0;
			this.woodObj.y=0;
			this.woodObj.width=100;
			this.woodObj.height=36;
			this.woodObj.mouseEnabled=false;
			addChild(this.woodObj);
			
			this.iron1=new Iron();
			this.iron1.x=20;
			this.iron1.y=7;
			this.iron1.width=21;
			this.iron1.height=12;
			this.iron1.mouseEnabled=false;
			addChild(this.iron1);
			
			this.iron2=new Iron();
			this.iron2.x=20;
			this.iron2.y=-2.8;
			this.iron2.width=21;
			this.iron2.height=12;
			this.iron2.mouseEnabled=false;
			addChild(this.iron2);
			
			this.switchButtonObj=new SwitchButton(); 
			this.switchButtonObj.x=-40;
			this.switchButtonObj.y=-5;
			this.switchButtonObj.width=60;
			this.switchButtonObj.height=60;
			this.switchButtonObj.mouseEnabled=false;
			addChild(this.switchButtonObj);
			this.doubleClickEnabled=true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,switchClose);
			
			myRadians=Math.atan2(this.switchButtonObj.height,this.switchButtonObj.width);
			myDegree=myRadians*(180/Math.PI);
		}
	
		// Public Methods:
		public function getPrevWidth():Number{
			return this.prevWidth;
		}
		
		public function setPrevWidth(w:Number){
			this.prevWidth=w;
		}
		
		public function closeTween():void{
			if(!this.parent.isClose){
				if(myTween!=null)
					myTween.stop();
				myTween=new Tween(this.switchButtonObj,"rotation",None.easeOut,0,myDegree,.1,true);
				myTween.start();
			}
			else{
				if(myTween!=null)
					myTween.stop();
				myTween=new Tween(this.switchButtonObj,"rotation",None.easeOut,myDegree,0,.1,true);
				myTween.start();		
			}
		}
		// Protected Methods:
		function switchClose(e:MouseEvent):void{
			e.target.closeTween();
			e.target.parent.schematicComponent.closeTween();
			if(!e.target.parent.isClose){
				Circuit.updateResistance(this.parent.parent.ids,1e-10)
				this.parent.resistance=1e-10;
				this.parent.isClose=true;
			}
			else{
				Circuit.updateResistance(this.parent.parent.ids,100000)
				this.parent.resistance=100000;
				this.parent.isClose=false;
			}
			Circuit.circuitAlgorithm();
			StageBuilder.voltmeterObj.updateVoltageReading();
		}
		
		
	}
	
}