package virtualcircuit.components{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
		
	public class VoltBody extends MovieClip{
		public var insideArea:Boolean;
		var redPinEnd:RedPinEnd;
		var blackPinEnd:BlackPinEnd;
		public var currText:TextField;
		var turn:VoltTurn;
		var vIndicator:Volts;
		var rIndicator:Ohms;
		var prevX:Number;
		var prevY:Number;
		var posX:Number;
		var posY:Number;
		var isRotate:Boolean;
		
		public function VoltBody(){
						
			this.insideArea=false;
			this.redPinEnd=new RedPinEnd();
			this.redPinEnd.x=11;
			this.redPinEnd.y=210;
			this.blackPinEnd=new BlackPinEnd();
			this.blackPinEnd.x=57;
			this.blackPinEnd.y=210;
								
			var format:TextFormat = new TextFormat();
			format.size = 50;
			//format.bold=true;
			format.color=0XFFFFFF;
			this.currText=new TextField();
			this.currText.width=150;
			this.currText.height=80;
			this.currText.y=-200;
			this.currText.x=30;
			this.currText.defaultTextFormat = format;
			this.currText.setTextFormat(format);
			this.currText.text="-----";
						
			this.buttonMode=true;
			this.redPinEnd.mouseEnabled=false;
			this.blackPinEnd.mouseEnabled=false;
			this.currText.mouseEnabled=false;
			
			this.turn=new VoltTurn();
			this.turn.x=82;
			this.turn.y=58;
			this.turn.mouseEnabled=true;
			this.turn.mouseChildren=false;
			this.turn.addEventListener(MouseEvent.MOUSE_DOWN,startRotate);
			
			this.vIndicator=new Volts();
			this.vIndicator.name="volts";
			this.vIndicator.scaleX=1.5;
			this.vIndicator.scaleY=1.5;
			this.vIndicator.x=15;
			this.vIndicator.y=30;
			this.rIndicator=new Ohms();
			this.rIndicator.name="ohms";
			this.rIndicator.x=157;
			this.rIndicator.y=30;
			this.rIndicator.scaleX=1.2;
			this.rIndicator.scaleY=1.2;
			
			this.graphics.lineStyle(1,0X000000,1,false,"normal",null,null,3);
			//this.graphics.drawRect(this.vIndicator.x,this.vIndicator.y,40,40);
			
			addChild(this.redPinEnd);
			addChild(this.blackPinEnd);
			addChild(this.currText);
			addChild(this.turn);
			addChild(this.vIndicator);
			addChild(this.rIndicator);
			
		}
		
		function startRotate(e:MouseEvent):void{
			this.isRotate=true;
			e.target.addEventListener(Event.ENTER_FRAME,rotate);
			this.vIndicator.addEventListener(Event.ENTER_FRAME,hit);
			this.rIndicator.addEventListener(Event.ENTER_FRAME,hit);
			e.target.parent.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAll);		
		}	
		
		function stopRotate(){
			this.isRotate=false;
			this.turn.removeEventListener(Event.ENTER_FRAME,rotate);			
			this.vIndicator.removeEventListener(Event.ENTER_FRAME,hit);
			this.rIndicator.removeEventListener(Event.ENTER_FRAME,hit);
		}	
		
		function stopAll(e:MouseEvent):void{
			if(this.isRotate){
				stopRotate();
			}
		}
		
		function rotate(e:Event):void{
			var yln=e.target.y-mouseY;//>0)?mouseY-e.target.y:e.target.y-mouseY;
			var xln=e.target.x-mouseX;//>0)?mouseX-e.target.x:e.target.x-mouseX;
			var angle:Number = Math.atan2(yln,xln);
			var myDegrees:Number = Math.round((angle*180/Math.PI));
			//if(myDegrees>=0 && myDegrees<=140)
				e.target.rotation=myDegrees;
		}	
		
		public function hit(e:Event):void{
			
			if(e.target.hitTestObject(this.turn.top)){
				stopRotate();
				if(e.target.name=="volts")
					this.currText.text="----V";
				else
					this.currText.text="----R";
			}
		}	
	}
}