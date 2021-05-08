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
		var prevWidth:Number;
		var leftBar:SwitchBar;
		var middleBar:SwitchBar;
		var rightBar:SwitchBar;
		var myTween:Tween;
		var whiteRect:Rect;
		// Initialization:
		public function SchematicSwitch() {
			this.leftBar=new SwitchBar();
			addChild(this.leftBar);
			this.middleBar=new SwitchBar();
			this.middleBar.rotation=-45;
			addChild(this.middleBar);
			this.rightBar=new SwitchBar();
			addChild(this.rightBar);
			//this.mouseEnabled=false;
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
		function switchClose(e:MouseEvent):void{
			e.target.closeTween();
			e.target.parent.realComponent.closeTween();
			
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