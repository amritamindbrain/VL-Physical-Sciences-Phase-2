package virtualcircuit.components {
	
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import virtualcircuit.logic.Circuit;
	
	public class Switch extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicSwitch;
		public var realComponent:RealSwitch;
		public var resistance:Number;
		public var isClose:Boolean;
		var myTween:Tween;
		
		// Private Properties:
	
		// Initialization:
		public function Switch() { 
			
			//super();
			this.schematicComponent=new SchematicSwitch();
			this.realComponent=new RealSwitch();
			
			this.realComponent.width=70;
			this.realComponent.height=55;
			this.schematicComponent.width=70;
			this.schematicComponent.height=20;
			this.resistance=100000;
			this.isClose=false;
			this.mouseEnabled=false;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			
		}
	
		// Public Methods:
		// Protected Methods:
		public function toggleView():void{
						
			if(!Circuit.isSchematic()){
				this.schematicComponent.visible=false;
				this.realComponent.visible=true;
			}
			else {
				this.realComponent.visible=false;
				this.schematicComponent.visible=true;
			}
					
		}
		
		public function setWireLength(len:Number){
			
			this.width=len;
			this.realComponent.setPrevWidth(this.realComponent.width);
		}
		
		public function setXY(xlen:Number,ylen:Number){
			
			this.realComponent.x=xlen;
			this.realComponent.y=ylen;
			this.schematicComponent.x=xlen;
			this.schematicComponent.y=ylen;
			this.setRegistration(this.realComponent.x,this.realComponent.y);
		}		
	}
	
}