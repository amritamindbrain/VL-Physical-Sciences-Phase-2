
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
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.logic.Utilities;
	import virtualcircuit.logic.collision.*;
	import virtualcircuit.userinterface.StageBuilder;
	
	public class NonContactAmmeter extends DynamicMovie{
		public var insideArea:Boolean;
		var target:Target;
		public var currText:TextField;
		public var format:TextFormat;
		var initX:Number;
		var initY:Number;
		var prevX:Number;
		var prevY:Number;
		var posX:Number;
		var posY:Number;
		var gf:GlowFilter;
		var collisionList:CollisionList;
		var collidedBranch:Branch;
		var isDrag:Boolean;
		
		public function NonContactAmmeter(){
			this.insideArea=false;
			this.mouseChildren=false;
			this.target=new Target();
			this.target.x=0;
			this.target.y=0;
			this.isDrag=false;
			this.currText=new TextField();
			this.initX=630;
			this.initY=380;
			this.posX=initX;
			this.posY=initY;
			this.prevX=posX;
			this.prevY=posY;
			this.currText.width=80;
			this.currText.height=40;
			this.currText.y=-15;
			this.currText.x=30;
			var format:TextFormat = new TextFormat();
		
			format.size = 26;
			this.currText..defaultTextFormat = format;
			this.currText.setTextFormat(format);
			
			this.addChild(this.target);
			
			this.currText.text="";
			this.format=new TextFormat(null,30,0x000000,null,null,null,null,null,null,null,null,null,null);
			this.currText.setTextFormat(format);
			this.addChild(currText);
			this.mouseChildren=false;
			this.buttonMode=true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);		
			this.addEventListener(MouseEvent.MOUSE_UP,endDrag);		
		}
		
		function beginDrag(e:MouseEvent):void{
			this.currText.text="---";
			this.setSelection(true);
			
			this.collisionList=new CollisionList(this.target);
			
			for(var i:int=0;i<Circuit.branches.length;i++){
				if(Circuit.branches[i].insideArea)
					collisionList.addItem(Circuit.branches[i]);
				
			}
			
			e.target.isDrag=true;
			this.addEventListener(Event.ENTER_FRAME,checkForCollision);
			
			e.target.parent.setChildIndex(e.target,e.target.parent.numChildren-1);
			e.target.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAll);
			e.target.startDrag();
		}
		
		function endDrag(e:MouseEvent):void{
			if(this.isDrag){
				
				try{
					this.stopDrag();
					this.checkBoundArea();
				}
			
				catch(ex:Error)
				{
					this.currText.text="-----";
				}
				collisionList.dispose();
				collisionList.swapTarget(this.target);
				if(collidedBranch!=null){
					collisionList.addItem(collidedBranch);
				}
				else{
					this.removeEventListener(Event.ENTER_FRAME,checkForCollision);
				}
				e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,stopAll);
				this.isDrag=false;
			}
		}		
		
		function stopAll(e:MouseEvent):void{
			if(this.isDrag){
				
				try{
					this.stopDrag();
					this.checkBoundArea();
				}
			
				catch(ex:Error)
				{
					this.currText.text="-----";
				}
				collisionList.dispose();
				collisionList.swapTarget(this.target);
				if(collidedBranch!=null){
					collisionList.addItem(collidedBranch);
				}
				else{
					this.removeEventListener(Event.ENTER_FRAME,checkForCollision);
				}
				this.isDrag=false;
			}
		}		
		
		function checkForCollision(e:Event){
			updateAmmeterReading();			
		}
		
		public function updateAmmeterReading(){
			var collisions:Array = collisionList.checkCollisions();		
			if(collisions.length){
				collidedBranch=collisions[0].object2;
				if(collidedBranch.type!="battery"){
					this.currText.text=Utilities.roundDecimal(collidedBranch.current,2)+"A";
				}
				else
					this.currText.text="---";				
			}
			else{
				collidedBranch=null;
				this.currText.text="---";
			}
			
		}
		
		function setSelection(stat:Boolean):void{
			
			if(stat==true){
				if(StageBuilder.selectedJn!=null){
					StageBuilder.selectedJn.filters=null;
					StageBuilder.selectedJn=null;
				}
				if(StageBuilder.selectedObj)
				StageBuilder.selectedObj.filters=null;
				this.gf=new GlowFilter(0Xff9932,0.3,11,11,3,BitmapFilterQuality.LOW,false,false);//0X660033//0XFFFF99
				this.filters=[this.gf];
				StageBuilder.selectedObj=this;
			}
			else
				this.filters=null;
		}
		
		public function setPos():void{
			this.x=this.prevX;
			this.y=this.prevY;
		}
		
		function checkBoundArea():Boolean{
			
			var boundRight:Number=this.parent.boundArea.x+this.parent.boundArea.width/2;
			var boundLeft:Number=this.parent.boundArea.x-this.parent.boundArea.width/2;
			var boundUp:Number=this.parent.boundArea.y-this.parent.boundArea.height/2;
			var boundDown:Number=this.parent.boundArea.y+this.parent.boundArea.height/2;
			
			var right:Number=this.x+this.width/2;
			var left:Number=this.x-this.width/2;
			var up:Number=this.y-this.height/2;
			var down:Number=this.y+this.height/2;
			
			if(right<boundRight && left>boundLeft && up>boundUp && down<boundDown){
				this.insideArea=true;
			}	
		
			
			if(this.insideArea){
				this.scaleX=.45;
				this.scaleY=.45;
				//right
				if(right>boundRight){
					this.prevX=initX;
					this.prevY=initY;
					this.setPos();
					this.scaleX=0.35;
					this.scaleY=0.35;
					this.currText.text="-----";
					this.insideArea=false;
				}
				//left
				else if(left<boundLeft){
					this.setPos();
				}
				//up
				else if(up<boundUp){
					this.setPos();
				}
				//down
				else if(down>boundDown){
					this.setPos();
				}	
				else{
					this.prevX=this.x;
					this.prevY=this.y;
				}
			}
			else{
				this.x=this.posX;
				this.y=this.posY;
			}				
		}
	}
}