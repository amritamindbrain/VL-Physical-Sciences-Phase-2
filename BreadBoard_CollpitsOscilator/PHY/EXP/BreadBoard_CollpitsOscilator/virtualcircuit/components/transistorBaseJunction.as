
	package virtualcircuit.components {
	
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	
	public class transistorBaseJunction extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicSwitch;
		public var realComponent:RealTransistorBaseJunction;
		public var resistance:Number;
		public var traIsClose:Boolean;
		var myTween:Tween;
		
		// Private Properties:
	
		// Initialization:
		public function transistorBaseJunction() { 
					
			//super();
			//this.schematicComponent=new SchematicSwitch();
			trace("krishna");
			this.realComponent=new RealTransistorBaseJunction();
	trace("krishna rama");
			this.realComponent.width=10;
			this.realComponent.height=100;
			//this.schematicComponent.width=70;
			//this.schematicComponent.height=20;
			this.resistance=100000;
			this.traIsClose=false;
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