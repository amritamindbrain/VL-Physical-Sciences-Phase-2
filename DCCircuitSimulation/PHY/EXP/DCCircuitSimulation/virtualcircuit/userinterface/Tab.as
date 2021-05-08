
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.userinterface {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Tab extends MovieClip{
		
		// Constants:
		// Public Properties:
		public var topPane:TopPane;
		public var txt:TextField;
		public var pane:Pane;
		public var box:Box;
		// Private Properties:
	
		// Initialization:
		public function Tab(n:String) {
			this.name=n;
			this.topPane=new TopPane();		
			this.topPane.buttonMode=true;
			var format=new TextFormat(null,12,null,null,null,null,null,null, "center",null,null, null, null);
			this.txt=new TextField();
			this.txt.text=n;
			this.txt.width=this.topPane.width;
			this.txt.setTextFormat(format,0,this.txt.length);
			this.txt.mouseEnabled=false;
			this.pane=new Pane();
			this.box=new Box();
			this.box.x=this.x;
			this.box.y=this.y-5;
			this.addChild(pane);
			this.addChild(topPane);
			this.addChild(txt);	
			this.addChild(box);			
		}
	
		// Public Methods:
		public function setPos(pX:Number,pY:Number){
			this.x=pX;
			this.y=pY;
		}
		
		public function setTopPos(topX:Number,topY:Number):void{
			this.topPane.x=topX;
			this.topPane.y=topY;
			this.txt.x=topX-this.topPane.width/2;
			this.txt.y=topY-this.topPane.height/2;
		}
		// Protected Methods:
	
				
	}
	
}