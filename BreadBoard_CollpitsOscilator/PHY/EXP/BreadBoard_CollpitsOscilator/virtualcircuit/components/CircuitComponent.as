package virtualcircuit.components{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.desktop.NativeDragManager;
	import virtualcircuit.userinterface.StageBuilder;
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Junction;
	import virtualcircuit.logic.Circuit;
    import flash.geom.ColorTransform;
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
		//trace("type "+comp.parent.type)
		//if(comp.parent.type=="longWire"){
			//trace(comp.parent.midJunction.neighbours.length)
		//}
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
	
	
		public function removeRotationListeners(comp:CircuitComponent):void{
			
			 for (i=0; i<comp.parent.startJunction.neighbours.length; i++) {
					comp.parent.startJunction.neighbours[i].jnc=comp.parent.startJunction;
					comp.parent.startJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
					this.moveTogether(comp.parent.startJunction.neighbours[i])
					this.updateWires(comp.parent.startJunction.neighbours[i]);				
			 }
								
			for (i=0; i<comp.parent.endJunction.neighbours.length; i++) {
				comp.parent.endJunction.neighbours[i].jnc=comp.parent.endJunction;
				comp.parent.endJunction.neighbours[i].removeEventListener(Event.ENTER_FRAME,moveAlong);
				this.moveTogether(comp.parent.endJunction.neighbours[i]);
				this.updateWires(comp.parent.endJunction.neighbours[i]);			
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
		function changeColour(color:Number):void {
			var colorInfo:ColorTransform=this.transform.colorTransform;

			// Set a random color for the ColorTransform object.
			colorInfo.color=color;

			//Apply the random color for the rectangle
			this.transform.colorTransform=colorInfo;
		}
		public function startDragging(e:MouseEvent) {
			
			
			
		    if(e.target.parent.parent.startJunction.juncConnectedBb==true || e.target.parent.parent.endJunction.juncConnectedBb==true || (e.target.parent.parent.baseJunction!=null && e.target.parent.parent.baseJunction.juncConnectedBb==true)){
			/*StageBuilder.selectedObj=e.target.parent.parent;
			StageBuilder.deleteComponent();
			var resistorObj:Branch=new Branch("resistor");
			resistorObj.scaleX=0.55;
			resistorObj.scaleY=0.55;
			resistorObj.setPrev(700,163);
			resistorObj.setPos();
			componentBox.addChild(resistorObj);*/
			if(e.target.parent.parent.startJunction.juncConnectedBb==true ){
			//StageBuilder.selectedObj=e.target.parent.parent;
			//StageBuilder.deleteComponent();
			// Circuit.splitJunction(e.target.parent.parent.startJunction);
			// e.target.parent.parent.startJunction.juncConnectedBb=false;
			/* e.target.parent.parent.startJunction.dropJunc.changeColour(0xCCFFFF);
			e.target.parent.parent.startJunction.hitNeed=false;
			e.target.parent.parent.startJunction.isSnapped=false;
			e.target.parent.parent.startJunction.hit==false;
			e.target.parent.parent.startJunction.dropJunc.alpha=.5;
			e.target.parent.parent.startJunction.dropJunc=null;*/
			//var colorInfo1:ColorTransform=this.transform.colorTransform;

			// Set a random color for the ColorTransform object.
			//colorInfo1.color="0xCCFFFF";

			//Apply the random color for the rectangle
			//e.target.parent.parent.startJunction.dropJunc.changeColour;
			//e.target.parent.parent.startJunction.dropJunc.graphics.lineStyle(1);
			//e.target.parent.parent.startJunction.dropTarget=null;
			//e.target.parent.parent.startJunction.addEventListener(Event.ENTER_FRAME,hitOnJunction);
			}
			if(e.target.parent.parent.endJunction.juncConnectedBb==true){
			//StageBuilder.selectedObj=e.target;
			//StageBuilder.deleteComponent();
			 
			 //Circuit.splitJunction(e.target.parent.parent.endJunction);
			 /*e.target.parent.parent.endJunction.juncConnectedBb=false;
			 e.target.parent.parent.endJunction.dropJunc.changeColour(0xCCFFFF);
			e.target.parent.parent.endJunction.hitNeed=false;
			e.target.parent.parent.endJunction.isSnapped=false;
			e.target.parent.parent.endJunction.hit==false;
			e.target.parent.parent.endJunction.dropJunc.alpha=.5;
			e.target.parent.parent.endJunction.dropJunc=null;*/
			//var colorInfo2:ColorTransform=this.transform.colorTransform;

			// Set a random color for the ColorTransform object.
			//colorInfo2.color="0xCCFFFF";

			//Apply the random color for the rectangle
			//e.target.parent.parent.startJunction.dropJunc.colorTransform=colorInfo2;
			//e.target.parent.parent.startJunction.dropJunc.graphics.lineStyle(1);
			//e.target.parent.parent.startJunction.dropJunc.graphics.drawRect(-10,-10,15,15);
			//e.target.parent.parent.endJunction.dropTarget=null;
			//  e.target.parent.parent.endJunction.addEventListener(Event.ENTER_FRAME,hitOnJunction);
			}
			/*if(e.target.parent.parent.baseJunction!=null){
			if(e.target.parent.parent.baseJunction.juncConnectedBb==true){
			 Circuit.splitJunction(e.target.parent.parent.baseJunction);
			 e.target.parent.parent.baseJunction.juncConnectedBb=false;
			  //e.target.parent.parent.endJunction.dropJunc.changeColour(0x8EFFFF);
			e.target.parent.parent.baseJunction.hitNeed=true;
			e.target.parent.parent.baseJunction.isSnapped=false;
			e.target.parent.parent.baseJunction.hit==false;
			e.target.parent.parent.baseJunction.dropJunc.alpha=.1;
			//e.target.parent.parent.endJunction.dropTarget=null;
			//  e.target.parent.parent.endJunction.addEventListener(Event.ENTER_FRAME,hitOnJunction);
			}
			}*/
		 }else
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
					if(e.target.parent.parent.type!="signalGenerator" && e.target.parent.parent.type!="CROinputTerminal" &&  e.target.parent.parent.type!="BatteryShade"){
					e.target.parent.parent.startDrag();
					}
					//trace(e.target.parent.parent);
					
					
					if(e.target.parent.parent.type=="ICchip"){
						//trace('ICchip '+e.target.parent.parent.numChildren)
						//trace('ICchip '+StageBuilder.lWireObj1)
						/*if(StageBuilder.lWireObj1 != null){
							for(var i=0;i<4;i++){
								//StageBuilder.lWireObj1.setPrev(e.target.parent.parent.x + 10 + i * 18,e.target.parent.parent.y-25);
								//StageBuilder.lWireObj1.setPos();
								StageBuilder.arr[i].setPrev(e.target.parent.parent.x + 10 + i * 18,e.target.parent.parent.y-25);
							}
						}*/
						
						e.target.parent.parent.addEventListener(Event.ENTER_FRAME,enterFn);
						
					}
					
					
					
					
					
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
						}//
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
					if(e.target.parent.parent.baseJunction!=null){
					for (i=0; i<e.target.parent.parent.baseJunction.neighbours.length; i++) {
						
					
						e.target.parent.parent.baseJunction.neighbours[i].jnc=e.target.parent.parent.baseJunction;
						if((e.target.parent.parent.type!="wire")||((e.target.parent.parent.type=="wire")&&(e.target.parent.parent.baseJunction.neighbours[i].parent.type=="wire"))){
							e.target.parent.parent.baseJunction.neighbours[i].addEventListener(Event.ENTER_FRAME,moveAlong);		
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
					}
						
					
					e.updateAfterEvent();
	
				}
			}
		
		}
		
		function enterFn(e:Event){
			StageBuilder.chipJun(e);
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
			//trace(transPt)
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
				//trace("stopDragging");
				
				if(e.target.parent.parent is Branch){
					e.target.parent.parent.stopDrag();
					
					
					
					if(e.target.parent.parent.type=="ICchip"){
						e.target.parent.parent.removeEventListener(Event.ENTER_FRAME,enterFn);
					}
					   
					   
					
					
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
					var boundUp:Number=e.target.parent.parent.parent.boundArea.y-e.target.parent.parent.parent.boundArea.height/2-30;
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