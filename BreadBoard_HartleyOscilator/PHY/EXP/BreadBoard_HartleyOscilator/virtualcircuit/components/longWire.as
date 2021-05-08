﻿
	package virtualcircuit.components {
	
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	
	public class longWire extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicSwitch;
		public var realComponent:RealLongWire;
		public var resistance:Number;
		public var isClose:Boolean;
		var myTween:Tween;
		
		// Private Properties:
	
		// Initialization:
		public function longWire() { 
					//trace("amma");
			//super();
			//this.schematicComponent=new SchematicSwitch();
			this.realComponent=new RealLongWire();
	
			this.realComponent.width=300;
			this.realComponent.height=10;
			//this.schematicComponent.width=70;
			//this.schematicComponent.height=20;
			this.resistance=000001;
			this.isClose=true;
			this.mouseEnabled=false;
			//this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			
		}
	
		// Public Methods:
		// Protected Methods:
		
		
		public function setWireLength(len:Number){
			
			this.width=len;
			this.realComponent.setPrevWidth(this.realComponent.width);
		}
		
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			//this.schematicComponent.x=xlen;
			//this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}		
	}
	
}