package virtualcircuit.components{

	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.ColorTransform;


	import virtualcircuit.logic.Circuit;
	import virtualcircuit.userinterface.StageBuilder;
	import virtualcircuit.logic.SubCircuit;
	import virtualcircuit.components.CircuitComponent;

	public class Junction extends DynamicMovie {
		// Constants:
		// Public Properties:
		public var opp:Boolean;
		public var ids:String;
		public var jType:String;
		public var hit:Boolean;
		public var neighbours:Array;
		public var jnc:Junction;
		public var pinType:String;
		public var isSnapped:Boolean;
		public var isHitWithRedPin:Boolean;
		public var isHitWithBlackPin:Boolean;
		public var selectedJunc:Junction;
		var noOfIteration=0;
		var gf:GlowFilter;
		var prevX:Number;
		var prevY:Number;
		public var lastX:Number;
		public var lastY:Number;
		public var stageObj:StageBuilder;
	    public var hitNeed=false;
		public var juncConnectedBb=false;
		public var dropJunc:midJunction;
		//public var crossedBound:Boolean;
		// Private Properties:

		// Initialization:
		var cm=new CircuitComponent();
		public static var addedInCircuit:Array=new Array();
		//public static var addedInCircuitIds:Array=new Array();
		//public function Junction(nam:String) {
		public function Junction() {
			this.jType="junction";
			this.isHitWithRedPin=false;
			this.isHitWithBlackPin=false;
			this.buttonMode=true;
			this.jnc=null;
			this.isSnapped=false;
			
			this.opp=false;
			this.hit=false;
			this.prevX=0;
			this.prevY=0;		
			this.neighbours=new Array();
			
			var h2=new MovieClip();
			h2.graphics.beginFill(0xFFFFFF);
			h2.graphics.lineStyle(1);

			this.graphics.beginFill(0xFF0000);
			this.graphics.lineStyle(1);

			h2.alpha=.1;
			this.alpha=.1;

			h2.x=50;
			h2.y=50;

			this.x=0;
			this.y=0;

			//h2.graphics.drawCircle(-10,-10,20);//
			//h2.graphics.drawEllipse(-10,-10,15,15);
			//this.graphics.drawCircle(-10,-10,20);//
			//this.graphics.drawEllipse(-10,-10,15,15);
							
			h2.graphics.drawEllipse(-10,-8,20,20);
			this.graphics.drawEllipse(-10,-8,20,20);
			this.addEventListener(MouseEvent.MOUSE_MOVE,highlightJunction);
			this.addEventListener(MouseEvent.MOUSE_OUT,removeHighlightJunction);
			this.addEventListener(MouseEvent.MOUSE_DOWN,drag);

		
		}
		
		function changeColour(color:Number):void {
			var colorInfo:ColorTransform=this.transform.colorTransform;

			// Set a random color for the ColorTransform object.
			colorInfo.color=color;

			//Apply the random color for the rectangle
			this.transform.colorTransform=colorInfo;
			this.graphics.lineStyle(1);
		}
		
		function highlightJunction(e:MouseEvent):void{
			
			this.alpha=0.5;
		
		}
		
		function removeHighlightJunction(e:MouseEvent):void{
			
			//this.filters=null;
			
			this.alpha=.15;
		
		}


		// Public Methods:
		public function setPos() {
			this.x=prevX;
			this.y=prevY;
		}
		public function setPrev(posX:Number,posY:Number) {
			this.prevX=posX;
			this.prevY=posY;
		}
		
		public function removeFromNeighbours():void{
			for(i=0;i<this.neighbours.length;i++){
				for(j=0;j<this.neighbours[i].neighbours.length;j++){
					if(this.neighbours[i].neighbours[j]==this){
						this.neighbours[i].neighbours.splice(j,1);
						if(this.neighbours[i].neighbours.length==0){
							this.neighbours[i].isSnapped=false;
						}
						break;
					}
				}
			}
		}
		
		public function splitJunctions():void{
			var j:int;
			
			for(i=0;i<this.neighbours.length;i++){
		       
				this.neighbours[i].ids=this.neighbours[i].name;
				this.neighbours[i].ids=this.neighbours[i].name;
				//this.neighbours[i].changeColour(0xFF0000);
				if(this.neighbours[i].parent.type=="wire"){
					if(this.neighbours[i]==this.neighbours[i].parent.startJunction){
						//this.splitDraw(this.neighbours[i],this.neighbours[i].parent.endJunction);
					}
					else{
						//this.splitDraw(this.neighbours[i],this.neighbours[i].parent.startJunction);
					}
				}
				
				//this.neighbours[i].isSnapped=false;
				this.neighbours[i].neighbours=new Array();
			}
			
			this.ids=this.name;
			//this.isSnapped=false;
			//this.setSelection(false);
			
			this.changeColour(0xFF0000);
			//this.filters=null;
			this.neighbours=new Array();	
		}
		
		function splitDraw(jn1:Junction,jn2:Junction){
			if((jn1.y-jn2.y)>=0){
				jn1.y=jn2.y+(jn1.y-jn2.y)*0.5;		
			}
			else if((jn2.y-jn1.y)>0){
				jn1.y=jn2.y-(jn2.y-jn1.y)*0.5;						
			}
			jn1.x=jn2.x+(jn1.x-jn2.x)*0.5;	
			jn1.parent.innerComponentRef.drawLine(jn2.x,jn2.y,jn1.x,jn1.y);
		}
		
		// Protected Methods:
		function drag(e:MouseEvent):void {
				this.setSelection(true);

		}


		function sdrag(e:Event):void {	
           
			e.target.parent.stopDrag();
		}
        //var hitNeed:Boolean;
		public function addListenerToJunction():void {
			//this.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
			this.addEventListener(Event.ENTER_FRAME,hitOnJunction);
		}
		public function hitComponentOnBreadBoard(componentStartJun,componentStartJunDropTarget):void {
			if ((componentStartJun!=null)&&(componentStartJunDropTarget is midJunction)) {
				if ((componentStartJun.hit==false)) {
					
					componentStartJun.isSnapped=true;
					componentStartJun.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
					componentStartJun.changeColour(0x000000);
					componentStartJun.dropTarget.changeColour(0x000000);
										
					var pdt:Point=new Point(componentStartJunDropTarget.x,componentStartJunDropTarget.y);
					var newPt:Point=new Point();
                  
					newPt=componentStartJunDropTarget.parent.localToGlobal(pdt);
					var transPt:Point=componentStartJun.parent.globalToLocal(newPt);
					componentStartJun.x=transPt.x;
					componentStartJun.y=transPt.y;

					var pt:Point=new Point(componentStartJun.x,componentStartJun.y);
					var i:int;

					updateCircuit(componentStartJun,componentStartJunDropTarget,componentStartJunDropTarget.ids,componentStartJun.ids);
															
					componentStartJun.stopDrag();
					componentStartJun.hit=true;
				}
			}else {
				if (componentStartJun.hit==true) {
					componentStartJun.hit=false;
				}
			}
			/*if ((componentEndJun!=null)&&(componentEndJunDropTarget is midJunction)) {	
				if ((componentEndJun.hit==false)) {
					componentEndJun.isSnapped=true;
					componentEndJun.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
					componentEndJun.changeColour(0x000000);
					componentEndJunDropTarget.changeColour(0x000000);
										
					var pdt:Point=new Point(componentEndJunDropTarget.x,componentEndJunDropTarget.y);
					var newPt:Point=new Point();

					newPt=componentEndJunDropTarget.parent.localToGlobal(pdt);
					var transPt:Point=componentEndJun.parent.globalToLocal(newPt);
					componentEndJun.x=transPt.x;
					componentEndJun.y=transPt.y;

					var pt:Point=new Point(componentEndJun.x,componentEndJun.y);
					var i:int;

					updateCircuit(componentEndJun,componentEndJunDropTarget,componentEndJunDropTarget.ids,componentEndJun.ids);
															
					componentEndJun.stopDrag();
					componentEndJun.hit=true;
				}
			} else {
				if (componentEndJun.hit==true) {
					componentEndJun.hit=false;
				}
			}			*/
		}
		//Bread board default connection hit test
		public function boardHitJunction(boardStartJun,boardEndJun){
			
			//if ((boardEndJun!=null)&&(boardEndJun is Junction)&& !isSnapOnOpp(boardStartJun,boardEndJun)) {
				
				if ((boardStartJun.hit==false)) {
					
					boardStartJun.isSnapped=true;
					//boardStartJun.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
					boardStartJun.changeColour(0x00FFFF);
					boardEndJun.changeColour(0x00FFFF);
										
					var pdt:Point=new Point(boardEndJun.x,boardEndJun.y);
					var newPt:Point=new Point();
				

					newPt=boardEndJun.parent.localToGlobal(pdt);
					var transPt:Point=boardStartJun.parent.globalToLocal(newPt);
					//boardStartJun.x=transPt.x;
					//boardStartJun.y=transPt.y;
				
					//if(boardEndJun.parent.type!="wire")	//COMMENTED
					//boardStartJun.parent.parent.setChildIndex(boardEndJun.parent,boardStartJun.parent.parent.numChildren-1);	//COMMENTED

					//var pt:Point=new Point(boardStartJun.x,boardStartJun.y);
					var i:int;

					updateCircuit1(boardStartJun,boardEndJun,boardEndJun.ids,boardStartJun.ids);
															
				}
					
		}
		
		
		function hitOnJunction(e:Event):void {
			//var pdt:Point;
			var hitOk:Boolean;
			
			//trace("hitOnJunction-"+e.target.dropTarget.parent.name.substr(e.target.dropTarget.parent.name.length-1,e.target.dropTarget.parent.name.length)+"---"+e.target);
			 noOfIteration++;
			//trace("Junction hitted::"+stageObj.hitNeed);
		
			/*if(e.target.dropTarget!=null && e.target.dropTarget is MovieClip ){
				
			trace("--------"+e.target.dropTarget.parent.type);
			if(e.target.dropTarget.parent.type=="capasitor"){
				var cName=e.target.dropTarget;
				//pdt=new Point(e.target.dropTarget.x,e.target.dropTarget.y);
			    dname=e.target.dropTarget.parent.getChildAt(1);
				 trace(dname.name);
				// e.target.dropTarget.parent.getChildAt(0).setChildIndex(e.target.dropTarget.parent,e.target.parent.numChildren-1);
			//e.target.dropTarget.setChildIndex(e.target.dropTarget.parent,e.target.dropTarget.numChildren-1);
			
			//trace("pdt-"+pdt.x);
			e.target.dropTarget.parent.setChildIndex(e.target.dropTarget.parent.getChildAt(1),e.target.dropTarget.parent.numChildren-1);
            pdt=new Point(e.target.dropTarget.parent.getChildByName(cName).x,e.target.dropTarget.parent.getChildByName(cName).y); 
			
			
			trace("second--"+e.target.dropTarget);
			hitOk=true;
			}
			}*/
		   /* if(e.target.dropTarget.name=="firstHit"){
			trace("test");
			pdt=new Point(e.target.dropTarget.x,e.target.dropTarget.y);
			e.target.dropTarget.mouseEnabled=false;
			e.target.dropTarget.parent.setChildIndex(e.target.dropTarget.parent.getChildByName("startJunc"),e.target.dropTarget.parent.numChildren-1);
			hitOk=true;
			}*/
			//var pointFixed:Boolean;
			/*try{
			if(e.target.dropTarget!=null){
			if(e.target.dropTarget.parent.type=="capasitor"){
				if(StageBuilder.midHitOk){
					if(StageBuilder.selectedJunction=="firstHit"){
						StageBuilder.selectedJunction="";
					
												///e.target.dropTarget.parent.setChildIndex(e.target.dropTarget.parent.getChildByName("startJunc"),e.target.dropTarget.parent.numChildren-1);
												pdt=new Point(StageBuilder.pointX-10,StageBuilder.pointY);
												trace("devi");
												pointFixed=true;
												
											}
				   hitOk=true;
				}
			}else{
				hitOk=true;
				pointFixed=false;
			}
			}
			}catch (error:Error) {
    				 // statements
					 hitOk=false;
					 pointFixed=false;
             }*/
						//if(hitOk){
				
			 
				if(e.target.dropTarget!=null  && e.target.dropTarget is midJunction && e.target.dropJunc!=e.target.dropTarget ){
				// e.target.dropTarget.addEventListener(MouseEvent.MOUSE_UP,selectedPos);	
		
				if(e.target.hitNeed==true){
					//trace(e.target.dropTarget);
					//e.target.dropTarget.width=200.5;
					//trace("midJunction"+e.target.dropTarget.parent.getChildIndex(e.target.dropTarget));
					//e.target.dropTarget.visible=false;
					//e.target.dropTarget.ids=e.target.ids;
					//trace("e.target.hit"+e.target.hit);
					//trace("e.target-"+e.target+"-"+"e.target.dropTarget"+e.target.dropTarget);
					//e.target.dropTarget.ids=e.target.ids;
						//trace("opp.ids-"+e.target.ids+"-"+"dropJunction.ids"+e.target.dropTarget.ids);
					//if(isOnOpp(e.target,e.target.dropTarget)) {
						
					
					if ((e.target.hit==false)) {
						//trace("Junction"+e.target.dropTarget.parent.getChildIndex(e.target.dropTarget));
						//e.target.isMidSnapped=true;
						
						e.target.isSnapped=true;
						e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
						//e.target.mouseEnabled=false;
						//e.target.changeColour(0xFFFFFF);
						//e.target.dropTarget.changeColour(0x000000);
						
											/*if(e.target.dropTarget.parent.type=="capasitor"){
												//trace(Circuit.hitObject);
												if(StageBuilder.selectedJunction=="firstHit"){
													pdt=new Point(e.target.dropTarget.x+10,e.target.dropTarget.y);
												}
												
											
												//if (e.target.hitTestObject(e.target.dropTarget.getChildByName("firstHit"))){
													//pdt=new Point(e.target.dropTarget.getChildByName("firstHit").x,e.target.dropTarget.getChildByName("firstHit").y);
												 // trace("amma");
												//}
												//pdt=new Point(this.pontMouseX,this.pontMouseY);
												//trace(e.target.dropTarget.getChildByName("firstHit"));
												//pdt=new Point(e.target.dropTarget.x,e.target.dropTarget.y);
											""}else{*/
						//if(pointFixed==false)
							//trace(e.target.dropTarget.x+","+e.target.dropTarget.y);
							var pdt1=new Point(e.target.dropTarget.x-5,e.target.dropTarget.y-5);
												
							var newPt1:Point=new Point();
							  
							newPt1=e.target.dropTarget.parent.localToGlobal(pdt1);
							var transPt1:Point=e.target.parent.globalToLocal(newPt1);
							e.target.x=transPt1.x;
							e.target.y=transPt1.y;
                    
						//if(e.target.dropTarget.parent.type!="wire")	//COMMENTED
							//e.target.parent.parent.setChildIndex(e.target.dropTarget.parent,e.target.parent.parent.numChildren-1);	//COMMENTED

							var pt1:Point=new Point(e.target.x,e.target.y);
							var p:int;
							trace("lengh--"+e.target.dropTarget.parent.name.length);
							//trace("addedInCircuit--"+addedInCircuit);
							//trace("addedInCircuit index==="+addedInCircuit.indexOf(e.target.dropTarget.parent.name+""));
							if(e.target.dropTarget.parent.name.substr(0,8)=="longWire"){
							if(addedInCircuit.indexOf(e.target.dropTarget.parent.name) < 0){
								addedInCircuit.push(e.target.dropTarget.parent.name+"");
								
								var aIndex=0;
								if(e.target.dropTarget.parent.name.length>=10){
								aIndex=e.target.dropTarget.parent.name.substr(e.target.dropTarget.parent.name.length-2,e.target.dropTarget.parent.name.length);
								}else{
									aIndex=e.target.dropTarget.parent.name.substr(e.target.dropTarget.parent.name.length-1,e.target.dropTarget.parent.name.length);
								}
								//Circuit.longWireArray[aIndex];
								Circuit.addComponent(Circuit.longWireArray[aIndex]);	
			                    Circuit.addBranchToList(Circuit.longWireArray[aIndex]);
							
							//Circuit.circuitAlgorithm();
							}
							}
							//Circuit.addComponent(lWireObj);	
			                //Circuit.addBranchToList(lWireObj);

						updateCircuit(e.target,e.target.dropTarget.parent.getChildAt(1),e.target.dropTarget.parent.getChildAt(1).ids,e.target.ids);
																//updateCircuit(e.target,e.target.dropTarget,e.target.dropTarget.ids+"",e.target.ids+"");
																
											e.target.juncConnectedBb=true;
											e.target.dropJunc=e.target.dropTarget;
											e.target.dropTarget.alpha=0.4;
											if(Circuit.addedInCircuitIds.indexOf(e.target.dropTarget.parent.ids)<0){
											     Circuit.addedInCircuitIds.push(e.target.dropTarget.parent.ids);
											}
											
						//trace(e.target,e.target.parent.parent.getChildAt(1));
						
						/*for (p=0; p<e.target.neighbours.length; p++) {
							if (! checkAlreadyExists(e.target.neighbours[p].neighbours,e.target.dropTarget.parent.getChildAt(2))) {
								e.target.neighbours[p].neighbours.push(e.target.dropTarget.parent.getChildAt(2));
							}
						}
						for (p=0; p<e.target.dropTarget.parent.getChildAt(2).neighbours.length; p++) {
							if (! checkAlreadyExists(e.target.dropTarget.parent.getChildAt(2).neighbours[p].neighbours,e.target)) {
								e.target.dropTarget.parent.getChildAt(2).neighbours[p].neighbours.push(e.target);
							}
						}
						
						if (! checkAlreadyExists(e.target.neighbours,e.target.dropTarget.parent.getChildAt(2))) {
							e.target.neighbours.push(e.target.dropTarget.parent.getChildAt(2));
						}
					
						for(p=0;i<e.target.dropTarget.parent.getChildAt(2).neighbours.length;p++){
							if(e.target!=e.target.dropTarget.neighbours[p]){
								if (! checkAlreadyExists(e.target.neighbours,e.target.dropTarget.parent.getChildAt(2).neighbours[p])) {
									e.target.neighbours.push(e.target.dropTarget.parent.getChildAt(2).neighbours[p]);
								}
							}
						}
					
						if (! checkAlreadyExists(e.target.dropTarget.parent.getChildAt(2).neighbours,e.target)) {
							e.target.dropTarget.parent.getChildAt(2).neighbours.push(e.target);
						}
					
						for(p=0;p<e.target.neighbours.length;p++){
							if(e.target.dropTarget.parent.getChildAt(2)!=e.target.neighbours[p]){
								if (! checkAlreadyExists(e.target.dropTarget.parent.getChildAt(2).neighbours,e.target.neighbours[p])) {
									e.target.dropTarget.parent.getChildAt(2).neighbours.push(e.target.neighbours[p]);
								}
							}
						}*/
						e.target.stopDrag();
						e.target.mouseEnabled=false;
						e.target.hit=false;
						e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
						//e.target.dropTarget=null;
						
				}
				
				
						e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
						
				}
				//e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
			    }
				
				/*} else {
				if (e.target.hit==true) {
					e.target.hit=false;
				}
					
					
					
				}*/
			
			 else if ((e.target.dropTarget!=null)&&(e.target.dropTarget is Junction )&& !isSnapOnOpp(e.target,e.target.dropTarget) && e.target.dropTarget.width!=20  ) {
				if ((e.target.hit==false)) {
					//trace("Junction"+e.target.dropTarget.parent.getChildIndex(e.target.dropTarget));
					e.target.isSnapped=true;
					e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
					e.target.changeColour(0x000000);
					e.target.dropTarget.changeColour(0x000000);
					
										/*if(e.target.dropTarget.parent.type=="capasitor"){
											//trace(Circuit.hitObject);
											if(StageBuilder.selectedJunction=="firstHit"){
												pdt=new Point(e.target.dropTarget.x+10,e.target.dropTarget.y);
											}
											
										
											//if (e.target.hitTestObject(e.target.dropTarget.getChildByName("firstHit"))){
												//pdt=new Point(e.target.dropTarget.getChildByName("firstHit").x,e.target.dropTarget.getChildByName("firstHit").y);
											 // trace("amma");
											//}
											//pdt=new Point(this.pontMouseX,this.pontMouseY);
											//trace(e.target.dropTarget.getChildByName("firstHit"));
											//pdt=new Point(e.target.dropTarget.x,e.target.dropTarget.y);
										}else{*/
					//if(pointFixed==false)
					//trace(e.target.dropTarget.x+","+e.target.dropTarget.y);
					var pdt=new Point(e.target.dropTarget.x,e.target.dropTarget.y);
										
					var newPt:Point=new Point();

					newPt=e.target.dropTarget.parent.localToGlobal(pdt);
					var transPt:Point=e.target.parent.globalToLocal(newPt);
					e.target.x=transPt.x;
					e.target.y=transPt.y;
  // trace("OK1");
					//if(e.target.dropTarget.parent.type!="wire")	//COMMENTED
					//e.target.parent.parent.setChildIndex(e.target.dropTarget.parent,e.target.parent.parent.numChildren-1);	//COMMENTED

					var pt:Point=new Point(e.target.x,e.target.y);
					var i:int;
                 
					updateCircuit(e.target,e.target.dropTarget,e.target.dropTarget.ids,e.target.ids);
															
					for (i=0; i<e.target.neighbours.length; i++) {
						if (! checkAlreadyExists(e.target.neighbours[i].neighbours,e.target.dropTarget)) {
							e.target.neighbours[i].neighbours.push(e.target.dropTarget);
						}
					}
					for (i=0; i<e.target.dropTarget.neighbours.length; i++) {
						if (! checkAlreadyExists(e.target.dropTarget.neighbours[i].neighbours,e.target)) {
							e.target.dropTarget.neighbours[i].neighbours.push(e.target);
						}
					}
					
					if (! checkAlreadyExists(e.target.neighbours,e.target.dropTarget)) {
						e.target.neighbours.push(e.target.dropTarget);
					}
					
					for(i=0;i<e.target.dropTarget.neighbours.length;i++){
						if(e.target!=e.target.dropTarget.neighbours[i]){
							if (! checkAlreadyExists(e.target.neighbours,e.target.dropTarget.neighbours[i])) {
								e.target.neighbours.push(e.target.dropTarget.neighbours[i]);
							}
						}
					}
					
					if (! checkAlreadyExists(e.target.dropTarget.neighbours,e.target)) {
						e.target.dropTarget.neighbours.push(e.target);
					}
					
					for(i=0;i<e.target.neighbours.length;i++){
						if(e.target.dropTarget!=e.target.neighbours[i]){
							if (! checkAlreadyExists(e.target.dropTarget.neighbours,e.target.neighbours[i])) {
								e.target.dropTarget.neighbours.push(e.target.neighbours[i]);
							}
						}
					}
					e.target.stopDrag();
					e.target.mouseEnabled=false;
					e.target.hit=true;
				}
				e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
			} else {
					if(noOfIteration>2){
						if(e.target.parent.type!="wire"){
						e.target.stopDrag();
						}
						e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
						e.target.hitNeed=false;
						noOfIteration=0;
					}
				if (e.target.hit==true) {
					e.target.hit=false;
				}
				
			}	
			//e.target.removeEventListener(Event.ENTER_FRAME,hitOnJunction);
		}

		function updateCircuit(hitter:Junction,hit:Junction,newName:String,oldName:String):void {
			trace("updateCircuit");
			var searchData:XMLList=Circuit.circuit.branch;

			var searchResults:XMLList = searchData.(hasOwnProperty('@startJunction') && @startJunction.toLowerCase() == oldName);//traces correclty
			
			for each (var item:XML in searchResults) {
				var temp:String=item.@index.toString();
				Circuit.circuit.branch.(@index==temp).@startJunction=newName;
			}
             trace("@startJunction");
			var searchResults2:XMLList = searchData.(hasOwnProperty('@endJunction') && @endJunction.toLowerCase() == oldName);//traces correclty

			for each (var item2:XML in searchResults2) {
				var tmp:String=item2.@index.toString();
				Circuit.circuit.branch.(@index==tmp).@endJunction=newName;
			}
			trace("@endJunction");
			/*var searchResults3:XMLList = searchData.(hasOwnProperty('@baseJunction') && @baseJunction.toLowerCase() == oldName);//traces correclty

			for each (var item3:XML in searchResults3) {
				var tmp1:String=item3.@index.toString();
				Circuit.circuit.branch.(@index==tmp1).@baseJunction=newName;
			}*/
			hitter.ids=hit.ids;		
			Circuit.circuitAlgorithm();
		}
		
        function updateCircuit1(hitter:Junction,hit:Junction,newName:String,oldName:String):void {
			
			var searchData:XMLList=Circuit.circuit.branch;

			var searchResults:XMLList = searchData.(hasOwnProperty('@startJunction') && @startJunction.toLowerCase() == oldName);//traces correclty
			
			for each (var item:XML in searchResults) {
				var temp:String=item.@index.toString();
				Circuit.circuit.branch.(@index==temp).@startJunction=newName;
			}

			var searchResults2:XMLList = searchData.(hasOwnProperty('@endJunction') && @endJunction.toLowerCase() == oldName);//traces correclty

			for each (var item2:XML in searchResults2) {
				var tmp:String=item2.@index.toString();
				Circuit.circuit.branch.(@index==tmp).@endJunction=newName;
			}
			/*var searchResults3:XMLList = searchData.(hasOwnProperty('@baseJunction') && @baseJunction.toLowerCase() == oldName);//traces correclty

			for each (var item3:XML in searchResults3) {
				var tmp1:String=item3.@index.toString();
				Circuit.circuit.branch.(@index==tmp1).@baseJunction=newName;
			}*/
			hitter.ids=hit.ids;		
			Circuit.circuitAlgorithm();
		}

		/*private function showList(list:XMLList):void {
			var item:XML;
			for each (item in list) {
				//trace("item: " + item.toXMLString());
			}
		}*/
		
		public function setSelection(stat:Boolean):void{
			
			if(stat==true){
				if(StageBuilder.selectedObj!=null){
					StageBuilder.selectedObj.filters=null;
					StageBuilder.selectedObj=null;
				}
				if(StageBuilder.selectedJn!=null)
				StageBuilder.selectedJn.filters=null;
				this.gf=new GlowFilter(0Xff9932,1,11,11,6,BitmapFilterQuality.LOW,false,false);//0X660033//0XFFFF99
				this.filters=[this.gf];
				StageBuilder.selectedJn=this;
			}
			else
				this.filters=null;
		}

		function processSearchXML(xmlData:XML, searchTerm:String):XMLList {
			var searchData:XMLList=xmlData.branch;
			var searchResults:XMLList = searchData.(hasOwnProperty('@startJunction') && @startJunction.toLowerCase() == searchTerm);//traces correclty
			if (! searchResults.length()) {
			} else {

			}

			return searchResults;
		}

		function stickTogether(e:Event,pair:Junction):void {

			
			if ((pair!=null)&&(e.target.toString()==pair.toString())) {
				
				var pdt:Point=new Point(e.target.x,e.target.y);
				var newPt:Point=new Point();

				newPt=e.target.parent.localToGlobal(pdt);
				var transPt:Point=pair.parent.globalToLocal(newPt);
				e.target.parent.setChildIndex(e.target,e.target.parent.numChildren-1);

				pair.x=transPt.x;
				pair.y=transPt.y;

				var pt:Point=new Point(e.target.x,e.target.y);


				e.target.stopDrag();
				e.target.hit=true;
			}
		}

		function localToLocal(fr:MovieClip, to:MovieClip,pt:Point):Point {
			return to.globalToLocal(fr.localToGlobal(pt));
		}

		function checkAlreadyExists(neighboursArray:Array,targetObj:Junction):Boolean {
			var flag:Boolean=false;

			for (var i:int=0; i<neighboursArray.length; i++) {
				if (neighboursArray[i].name==targetObj.name) {
					flag=true; 
					break;
				}
			}
			return flag;
		}
		function isOnOpp(junction:Junction,dropJunction1:midJunction):Boolean{
			var opp1:Junction;
			if(junction.parent.startJunction.ids==junction.ids){
				opp1=junction.parent.startJunction;
			}
			else{
				opp1=junction.parent.endJunction;
			}
			//trace("opp.ids-out-"+opp1.ids+"-"+"dropJunction.ids"+dropJunction1.ids);
			if(opp1.ids==dropJunction1.ids){
				//trace("opp.ids-in -"+opp1.ids+"-"+"dropJunction.ids"+dropJunction1.ids);
				return true;
			}
			for(var i=0;i<opp1.neighbours.length;i++){
				var nextOpp:Junction;
				if(opp.neighbours[i].parent.startJunction.ids==opp.neighbours[i].ids){
					nextOpp=opp.neighbours[i].parent.endJunction;
				}
				else{
					nextOpp=opp.neighbours[i].parent.startJunction;
				}
				if(nextOpp.ids==dropJunction.ids || opp1.neighbours[i].ids==dropJunction.ids){
					return true;
				}
			}
			return false;
		}
		
		function isSnapOnOpp(junction:Junction,dropJunction:Junction):Boolean{
			var opp:Junction;
			if(junction.parent.startJunction.ids==junction.ids){
				opp=junction.parent.endJunction;
			}
			else{
				opp=junction.parent.startJunction;
			}
			if(opp.ids==dropJunction.ids){
				return true;
			}
			for(var i=0;i<opp.neighbours.length;i++){
				var nextOpp:Junction;
				if(opp.neighbours[i].parent.startJunction.ids==opp.neighbours[i].ids){
					nextOpp=opp.neighbours[i].parent.endJunction;
				}
				else{
					nextOpp=opp.neighbours[i].parent.startJunction;
				}
				if(nextOpp.ids==dropJunction.ids || opp.neighbours[i].ids==dropJunction.ids){
					return true;
				}
			}
			return false;
		}
		
		function printNeighbours(){
			//trace("Junction:",this.name);
			for(var i:int=0;i<this.neighbours.length;i++){
				trace(this.neighbours[i].name);
			}			
		}

	}
}