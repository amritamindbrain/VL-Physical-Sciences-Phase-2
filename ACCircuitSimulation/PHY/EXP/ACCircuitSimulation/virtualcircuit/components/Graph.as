
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
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import virtualcircuit.logic.Utilities;
	
	public class Graph extends MovieClip{
		var linem:MovieClip;
		
		var myArrayX:Array; 
		var myArrayY:Array; 
		
		var amplitude:Number;// This is the amplitude
		var startX:Number;// This is the starting x-position
		var centerY:Number;// This is the center of the wave
		
		var lineThickness:Number;// change this value to change the thickness
		var lineColor:uint;//change this value to change the color (keep the 0x in front)
		// This is the code
		var startY:Number;
		var angle:Number;
		var xVal:Number;
		var yVal:Number;
		var pxVal:Number;
		var pyVal:Number;
		var t:Number;
		var omega:Number;
		var maskBox:MovieClip;
		var affineTransform:Matrix;
		var originX:Number;
		var originY:Number;
		
		public function Graph(startX:Number,startY:Number,len:Number,ht:Number,color:uint,thickness:Number){
			this.linem =new MovieClip();
			addChild(linem);
						
			this.myArrayX= new Array();
			this.myArrayY= new Array();
			
			this.amplitude=0;
			this.startX=startX;
			this.centerY=startY;
			
			this.maskBox = new MovieClip();
			this.maskBox.graphics.lineStyle(1,0X000000);
			this.maskBox.graphics.beginFill(0X000000,1);
			this.maskBox.graphics.drawRect(0,10,len,ht);
			this.maskBox.graphics.endFill();
			addChild(this.maskBox);
			linem.mask=this.maskBox;
			
			lineThickness=thickness;
			lineColor=color;
				
			this.startY=centerY;
			this.angle=0;
			this.xVal=startX;
			this.yVal=startY;
			this.pxVal=startX;
			this.pyVal=startY;
			t=0;
			omega=5000*10*Math.PI;
		
			while (xVal<len) {			
				myArrayX.push(xVal);
				myArrayY.push(yVal);
				xVal=xVal+1;				
			}
			originX = this.maskBox.x+this.maskBox.width/2;
			originY = this.maskBox.y+this.maskBox.height/2;
			
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}
		
		function drawArc(newY:Number) {		
			linem.graphics.clear();
			var i:uint;
			var j:uint;
			
			yVal=centerY-newY;
			myArrayY.pop();
			myArrayY.reverse();
			myArrayY.push(yVal);
			myArrayY.reverse();
			drawWave();
			
			startY=startY-yVal;
		}
		
		function getNewY():Number{
			angle=Utilities.roundDecimal(omega*t);
			t=t+.000001;
			return (Math.sin(angle)*amplitude);
		}
		
		function drawWave() {
			var i:uint;
			linem.graphics.moveTo(pxVal, pyVal);
			for (i=0; i<myArrayX.length; i++) {
				linem.graphics.lineStyle(lineThickness,lineColor);
				linem.graphics.lineTo(myArrayX[i],myArrayY[i]);
				linem.graphics.moveTo(myArrayX[i],myArrayY[i]);
				linem.graphics.lineTo(myArrayX[i],myArrayY[i]);		
			}
			addChild(linem);
		}
		
		public function setAmplitude(newAmp:Number){
			this.amplitude=newAmp;
		}
		
		public function scaleAt( scale : Number) : void
		{
				affineTransform = linem.transform.matrix;
				affineTransform.translate( -originX, -originY );
				affineTransform.scale( 1, scale );
				affineTransform.translate( originX, originY );
				linem.transform.matrix = affineTransform;		
				affineTransform = linem.transform.matrix;
				
		}
	}
}