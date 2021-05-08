package virtualcircuit.components {
	
	import virtualcircuit.logic.Circuit;
	
	public class Resistor extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		public var schematicComponent:SchematicResistor;
		public var realComponent:RealResistor;
		public var resistance:Number;
		public var ObjRotation:Number;
		/*public var prvX:Number;
		public var prvY:Number;
		public var curX:Number;
		public var curY:Number;*/
		// Private Properties:
	
		// Initialization:
		public function Resistor() { 
			
			this.schematicComponent=new SchematicResistor();
			this.realComponent=new RealResistor();
			this.realComponent.width=100;
			this.realComponent.height=25;
			this.schematicComponent.width=100;
			this.schematicComponent.height=25;
			this.setResistance(1000);
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			this.mouseEnabled=false;
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
		
		public function setResistance(resistance:Number):void{
			this.resistance=resistance;
			this.realComponent.getColorBands(resistance);
		}
		
	}
	
}