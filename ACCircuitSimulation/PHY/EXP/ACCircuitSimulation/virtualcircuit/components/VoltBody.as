/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.components{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
		
	public class VoltBody extends MovieClip{
		public var insideArea:Boolean; //Boolean indicating if the VoltBody is inside the Area
		var redPinEnd:RedPinEnd;	//Object of redPinEnd
		var blackPinEnd:BlackPinEnd; //Object of redPinEnd
		public var currText:TextField; //TextField to display the voltage
		var turn:VoltTurn; //Object of VoltTurn the nob of the voltmeter
		var prevX:Number;
		var prevY:Number;
		var posX:Number;
		var posY:Number;
		
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
			format.color=0XFFFFFF;
			this.currText=new TextField();
			this.currText.width=180;
			this.currText.height=80;
			this.currText.y=-200;
			this.currText.x=10;
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
			this.turn.mouseEnabled=false;
			this.turn.mouseChildren=false;
			
			
			this.graphics.lineStyle(1,0X000000,1,false,"normal",null,null,3);
			
			addChild(this.redPinEnd);
			addChild(this.blackPinEnd);
			addChild(this.currText);
			addChild(this.turn);
			
			
		}
		
		
	}
}