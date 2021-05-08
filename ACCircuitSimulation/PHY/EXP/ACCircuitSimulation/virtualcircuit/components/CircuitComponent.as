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
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.desktop.NativeDragManager;
	import virtualcircuit.userinterface.StageBuilder;
	import virtualcircuit.components.Branch;
	
	public class CircuitComponent extends DynamicMovie {

		// Constants:
		// Public Properties:
		var nameX:String;	
		var schematicView:Boolean;	
		var jnc:Object;	
		var xDiff:Number;
		var yDiff:Number;
		// Private Properties:
		
		static var stageFlag:Boolean=false;
		// Initialization:
		
		public function CircuitComponent() {

			this.schematicView=false;
			this.jnc=null;
			this.addEventListener(MouseEvent.MOUSE_DOWN,addSelection);
			this.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);
			this.addEventListener(MouseEvent.MOUSE_UP,stopDragging);
			this.buttonMode=true;
		}
		
	
		/////////////////////////////////////////////////////////////////
		
		function forRotation(comp:CircuitComponent):void{
		
			if(comp.parent.type!="wire")
			comp.parent.parent.setChildIndex(comp.parent,comp.parent.parent.numChildren-1);
				
			 for (i=0; i<comp.parent.startJunction.neighbours.length; i++) {
					comp.parent.startJunction.neighbours[i].jnc=comp.parent.startJunction;
					if((comp.parent.type!="wire")||((comp.parent.type=="wire")&&(comp.parent.startJunction.neighbours[i].parent.type=="wire"))){
						comp.parent.startJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveAlong);
					}
			 }			
				
			for (i=0; i<comp.parent.endJunction.neighbours.length; i++) {
				comp.parent.endJunction.neighbours[i].jnc=comp.parent.endJunction;
				if((comp.parent.type!="wire")||((comp.parent.type=="wire")&&(comp.parent.endJunction.neighbours[i].parent.type=="wire"))){
					comp.parent.endJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveAlong);
				}			
			}
		}	
	
	
		function removeRotationListeners(comp:CircuitComponent):void{
	
			 for (i=0; i<comp.parent.startJunction.neighbours.length; i++) {
					comp.parent.startJunction.neighbours[i].jnc=comp.parent.startJunction;
					if((comp.parent.type!="wire")||((comp.parent.type=="wire")&&(comp.parent.startJunction.neighbours[i].parent.type=="wire"))){
						comp.parent.startJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
						this.moveTogether(comp.parent.startJunction.neighbours[i])
						this.updateWires(comp.parent.startJunction.neighbours[i]);				
					}
			 }
					
				
				
			for (i=0; i<comp.parent.endJunction.neighbours.length; i++) {
				comp.parent.endJunction.neighbours[i].jnc=comp.parent.endJunction;
				if((comp.parent.type!="wire")||((comp.parent.type=="wire")&&(comp.parent.endJunction.neighbours[i].parent.type=="wire"))){
					comp.parent.endJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
					this.moveTogether(comp.parent.endJunction.neighbours[i]);
					this.updateWires(comp.parent.endJunction.neighbours[i]);			
				}		
			}
	
		}
	
			
			
		/////////////////////////////////////////////////////////////////
	
		// Public Methods:
		function stopAllDrags(e:MouseEvent):void
		{
			if(this.parent.parent!=null){
				if(this.parent is Branch){
					
					var pt1:Point=this.parent.localToGlobal(new Point(this.parent.startJunction.x,this.parent.startJunction.y));
					var pt2:Point=this.parent.localToGlobal(new Point(this.parent.endJunction.x,this.parent.endJunction.y));
					
					this.parent.setRegistration(this.parent.width/2,this.parent.height/2);
					
					var boundRight:Number=this.parent.parent.boundArea.x+this.parent.parent.boundArea.width/2;
					var boundLeft:Number=this.parent.parent.boundArea.x-this.parent.parent.boundArea.width/2-50;
					var boundUp:Number=this.parent.parent.boundArea.y-this.parent.parent.boundArea.height/2;
					var boundDown:Number=this.parent.parent.boundArea.x+this.parent.parent.boundArea.height/2+40;
					
					var right:Number=this.parent.x+this.parent.width/2;
					var left:Number=this.parent.x-this.parent.width/2;
					var up:Number=this.parent.y-this.parent.height/2;
					var down:Number=this.parent.y+this.parent.height/2;
					
					if(this.parent is Branch){
						if (this.parent.insideArea) {
							//right
							if (right>boundRight) {
								this.parent.setPos();
							}
							//left
							else if (left<boundLeft) {
								this.parent.setPos();
							}
							//up
							else if (up<boundUp) {
								this.parent.setPos();
							}
							//down
							else if (down>boundDown) {
								this.parent.setPos();
							}
							else{
								this.parent.setPrev(this.parent.x,this.parent.y);
							}
						}
						else{
								this.parent.setPos();
						}
					}
					this.parent.stopDrag();
				}
			}
		}
			
			
		public function addSelection(e:MouseEvent){
			
			if(this.parent is Branch){			//NEED REVISION
				this.parent.setSelection(true);
			}				
			else{
				
				this.parent.parent.setSelection(true);
			}
		}
			
		public function startDragging(e:MouseEvent) {
			if(e.target.parent.parent is Branch){
				var nFlag:Boolean=false;
				
				this.parent.parent.parent.addEventListener(MouseEvent.MOUSE_UP,stopAllDrags);
							
				 for (i=0; i<e.target.parent.parent.startJunction.neighbours.length; i++) {
					 if(e.target.parent.parent.startJunction.neighbours[i].parent.type!="wire")
					 {
						 nFlag=true;
					 }				 
				 }
				
				 for (i=0; i<e.target.parent.parent.endJunction.neighbours.length; i++) {
					  if(e.target.parent.parent.endJunction.neighbours[i].parent.type!="wire")
					 {
						 nFlag=true;
					 }				 
				 }
				 
				 if(!nFlag)
				 {
					e.target.parent.parent.startDrag();
					if(e.target.parent.parent.type!="wire")
						e.target.parent.parent.parent.setChildIndex(e.target.parent.parent,e.target.parent.parent.parent.numChildren-1);
				 }
			
				if(true){										//condition: e.target.parent.parent.type!="wire"
					
				 for (i=0; i<e.target.parent.parent.startJunction.neighbours.length; i++) {
						e.target.parent.parent.startJunction.neighbours[i].jnc=e.target.parent.parent.startJunction;
						if((e.target.parent.parent.type!="wire")||((e.target.parent.parent.type=="wire")&&(e.target.parent.parent.startJunction.neighbours[i].parent.type=="wire"))){
								e.target.parent.parent.startJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveAlong);
						}
						else{
							//trace("wire")
							//this.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
							//this.removeEventListener(MouseEvent.MOUSE_UP,stopDragging);
						}
					}
			
						
					for (i=0; i<e.target.parent.parent.endJunction.neighbours.length; i++) {
						e.target.parent.parent.endJunction.neighbours[i].jnc=e.target.parent.parent.endJunction;
						if((e.target.parent.parent.type!="wire")||((e.target.parent.parent.type=="wire")&&(e.target.parent.parent.endJunction.neighbours[i].parent.type=="wire"))){
							e.target.parent.parent.endJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveAlong);		
						}			
						else{
							/*var pdt:Point=new Point(e.target.parent.parent.endJunction.x,e.target.parent.parent.endJunction.y);
							var newPt:Point=e.target.parent.parent.endJunction.parent.localToGlobal(pdt);
							var transPt:Point=e.target.parent.globalToLocal(newPt);
							e.target.parent.parent.endJunction.neighbours[i].parent.innerComponent.xDiff=Math.abs(e.target.parent.parent.endJunction.neighbours[i].parent.x-transPt.x);
							e.target.parent.parent.endJunction.neighbours[i].parent.innerComponent.yDiff=Math.abs(e.target.parent.parent.endJunction.neighbours[i].parent.y-transPt.y);				
							e.target.parent.parent.endJunction.lastX=e.target.parent.parent.endJunction.x;
							e.target.parent.parent.endJunction.lastY=e.target.parent.parent.endJunction.y;
							e.target.parent.parent.endJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveComponent);		*/
							//this.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
							//this.removeEventListener(MouseEvent.MOUSE_UP,stopDragging);			
						}
					}		
					e.updateAfterEvent();
	
				}
			}
		}
	
	
		function moveAlong(e:Event):void {
			
			var pdt:Point=new Point(e.target.jnc.x,e.target.jnc.y);
			var newPt:Point=new Point();
			newPt=e.target.jnc.parent.localToGlobal(pdt);
			var transPt:Point=e.target.parent.globalToLocal(newPt);
			e.target.x=transPt.x;
			e.target.y=transPt.y;
			if(e.target.parent.type=="wire"){
				if(e.target.opp){
					e.target.parent.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.startJunction.x,e.target.parent.startJunction.y);		
				}
				else{
					e.target.parent.innerComponentRef.drawLine(e.target.x,e.target.y,e.target.parent.endJunction.x,e.target.parent.endJunction.y);
					
				}
			}
			
		}
		function moveComponent(e:Event):void {
			
			var pdt:Point=new Point(e.target.jnc.x,e.target.jnc.y);
			var newPt:Point=e.target.jnc.parent.localToGlobal(pdt);
			var transPt:Point=e.target.parent.globalToLocal(newPt);
			trace(transPt)
			e.target.parent.x=transPt.x-e.target.parent.innerComponent.xDiff;
			//e.target.parent.y=transPt.y+;
			
		}
		function moveTogether(junction:Junction):void {
			
			var pdt:Point=new Point(junction.jnc.x,junction.jnc.y);
			var newPt:Point=new Point();
			newPt=junction.jnc.parent.localToGlobal(pdt);
			var transPt:Point=junction.parent.globalToLocal(newPt);
			junction.x=transPt.x;
			junction.y=transPt.y;
		
			if(junction.parent.type=="wire"){
				if(junction.opp){
					
					junction.parent.innerComponentRef.drawLine(junction.x,junction.y,junction.parent.startJunction.x,junction.parent.startJunction.y);		
					
				}
				else{
					
					junction.parent.innerComponentRef.drawLine(junction.x,junction.y,junction.parent.endJunction.x,junction.parent.endJunction.y);
		
				}
			}
		
		}
	
		function stopDragging(e:MouseEvent) {
			
				
				if(e.target.parent.parent is Branch){
					e.target.parent.parent.stopDrag();
							
					e.target.parent.parent.setRegistration(e.target.parent.parent.width/2,e.target.parent.parent.height/2);
					
					
					function delay(n:int):void
					{
						var xx1:Number=0;
						for(var i=0;i<1000*n;i++){
							for(var j=0;j<1000;j++){
								
								xx1=Math.sqrt(i*j);
							}
						}
					}
					var boundRight:Number=e.target.parent.parent.parent.boundArea.x+e.target.parent.parent.parent.boundArea.width/2;
					var boundLeft:Number=e.target.parent.parent.parent.boundArea.x-e.target.parent.parent.parent.boundArea.width/2-50;
					var boundUp:Number=e.target.parent.parent.parent.boundArea.y-e.target.parent.parent.parent.boundArea.height/2;
					var boundDown:Number=e.target.parent.parent.parent.boundArea.x+e.target.parent.parent.parent.boundArea.height/2+40;
					
					var right:Number=e.target.parent.parent.x+e.target.parent.parent.width/2;
					var left:Number=e.target.parent.parent.x-e.target.parent.parent.width/2;
					var up:Number=e.target.parent.parent.y-e.target.parent.parent.height/2;
					var down:Number=e.target.parent.parent.y+e.target.parent.parent.height/2;
				
					if((e.target.parent.parent is Branch) && !e.target.parent.parent.insideArea){
						if(right<boundRight && left>boundLeft && up>boundUp && down<boundDown){
							e.target.parent.parent.insideArea=true;
						}	
					}
					if (e.target.parent.parent.insideArea) {
						//right
						if (right>boundRight) {
							e.target.parent.parent.setPos();
						}
						//left
						else if (left<boundLeft) {
							e.target.parent.parent.setPos();
						}
						//up
						else if (up<boundUp) {
							e.target.parent.parent.setPos();
						}
						//down
						else if (down>boundDown) {
							e.target.parent.parent.setPos();
						}
						else{
							e.target.parent.parent.setPrev(e.target.parent.parent.x,e.target.parent.parent.y);
						}
					}
					else{
							e.target.parent.parent.setPos();		
					}	
		
					for (i=0; i<e.target.parent.parent.startJunction.neighbours.length; i++) {
			
						var startJunc:Junction=e.target.parent.parent.startJunction;
						e.target.parent.parent.startJunction.neighbours[i].jnc=e.target.parent.parent.startJunction;
						if((e.target.parent.parent.type!="wire")||((e.target.parent.parent.type=="wire")&&(e.target.parent.parent.startJunction.neighbours[i].parent.type=="wire"))){
							e.target.parent.parent.startJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
							this.moveTogether(e.target.parent.parent.startJunction.neighbours[i])
							this.updateWires(e.target.parent.parent.startJunction.neighbours[i]);
						}
					}
					
					for (i=0; i<e.target.parent.parent.endJunction.neighbours.length; i++) {
						var endJunc:Junction=e.target.parent.parent.endJunction;
						e.target.parent.parent.endJunction.neighbours[i].jnc=e.target.parent.parent.endJunction;
						if((e.target.parent.parent.type!="wire")||((e.target.parent.parent.type=="wire")&&(e.target.parent.parent.endJunction.neighbours[i].parent.type=="wire"))){
							e.target.parent.parent.endJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
							this.moveTogether(e.target.parent.parent.endJunction.neighbours[i])
							this.updateWires(e.target.parent.parent.endJunction.neighbours[i]);
						}
					}
				}
		}
	
		function isSchematicView() {
		
			return this.schematicView;
		}
	
	
		// Protected Methods:
		function updateWires(junction:Junction){
			
			if(junction.parent.type=="wire"){
				if(junction.opp){
					junction.parent.innerComponentRef.drawLine(junction.x,junction.y,junction.parent.startJunction.x,junction.parent.startJunction.y);	
				}
				else{			
					junction.parent.innerComponentRef.drawLine(junction.x,junction.y,junction.parent.endJunction.x,junction.parent.endJunction.y);
				}
			}
			
		}

	}

}