
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
	import flash.events.MouseEvent;
	
	public class TabbedPane extends MovieClip{
		
		// Constants:
		// Public Properties:
		public var tabs:Array;
		var xPos:Number;
		var nextButton:Next;
		var prevButton:Prev;
		var count:Number;
		// Private Properties:
	
		// Initialization:
		public function TabbedPane() {
			this.tabs=new Array();
			this.xPos=0;
		}
	
		// Public Methods:
		public function setPos(pX:Number,pY:Number):void{
			this.x=pX;
			this.y=pY;
			this.nextButton=new Next();
			this.nextButton.name="next";
			this.nextButton.x=83;
			this.nextButton.y=-40;
			this.nextButton.width=18;
			this.nextButton.height=18;
			this.prevButton=new Prev();
			this.prevButton.name="prev";
			this.prevButton.x=-83;
			this.prevButton.y=-40;
			this.prevButton.width=18;
			this.prevButton.height=18;
			this.nextButton.visible=false;
			this.prevButton.visible=false;
			this.count=0;
			this.nextButton.addEventListener(MouseEvent.CLICK,nextTab);
			this.prevButton.addEventListener(MouseEvent.CLICK,nextTab);
			this.addChild(nextButton);
			this.addChild(prevButton);
		}
		public function addTab(tabName:String):Pane{
			var tab=new Tab(tabName);
			tab.setPos(0,10);
			tab.setTopPos(tab.pane.x-tab.pane.width/2+tab.topPane.width/2+this.xPos,tab.pane.y-tab.pane.height/2-tab.topPane.height/2);
			if(this.xPos<110){
				this.xPos=this.xPos+55;
			}
			else{
				this.xPos=0;
			}
			this.addChild(tab);
			tab.topPane.addEventListener(MouseEvent.CLICK,switchTab);
			if(this.tabs.length>=3){
				tab.visible=false;
			}
			this.tabs.push(tab);
			this.setChildIndex(this.nextButton,this.numChildren-1);		
			this.setChildIndex(this.prevButton,this.numChildren-2);	
			if(this.tabs.length>3){
				this.nextButton.visible=true;
			}
			return tab.pane;
		}
		
		public function getTabInstance(tab:String):Pane{
			for(var i=0;i<tabs.length;i++){
				if(tabs[i].name==tab)
					return tabs[i].pane;
						
			}
			return null;
		}
		
		public function switchToTab(t:String):void{
			for(var i=0;i<this.tabs.length;i++){
				if(this.tabs[i].name==t){
					this.tabs[i].pane.visible=true;
					this.setChildIndex(tabs[i],this.numChildren-3);					
				}
				else{
					this.tabs[i].pane.visible=false;
				}
			}
		}
		
		public function nextTab(e:MouseEvent){
	
			if(e.target.name=="next"){
				this.count=this.count+3;
				if(this.count+3>=this.tabs.length){
					e.target.visible=false;
				}
				this.prevButton.visible=true;
			}
			else{
				this.count=this.count-3;
				if(this.count<=0){
					e.target.visible=false;
				}
				this.nextButton.visible=true;
			}
			
			for(var j:Number=0;j<this.tabs.length;j++){
				if(j>=count && j<count+3){	
					this.tabs[j].visible=true;
				}else{
					this.tabs[j].visible=false;
				}
			}
			switchToTab(this.tabs[count].name);
			
		}
		// Protected Methods:
		function switchTab(e:MouseEvent){
			switchToTab(e.target.parent.name);			
		}
		
		
	
				
	}
	
}