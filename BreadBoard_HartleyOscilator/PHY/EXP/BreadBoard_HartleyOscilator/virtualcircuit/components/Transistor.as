
	package virtualcircuit.components {
	
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	
	public class Transistor extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicSwitch;
		public var realComponent:RealTransistor;
		public var resistance:Number;
		public var traIsClose:Boolean;
		var myTween:Tween;
		public var ObjRotation:Number;
		
		// Private Properties:
	
		// Initialization:
		public function Transistor() { 
					
			//super();
			//this.schematicComponent=new SchematicSwitch();
			this.realComponent=new RealTransistor();
	
			this.realComponent.width=50;
			this.realComponent.height=50;
			//this.schematicComponent.width=70;
			//this.schematicComponent.height=20;
			this.resistance=0.0000000001;
			this.traIsClose=true;
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