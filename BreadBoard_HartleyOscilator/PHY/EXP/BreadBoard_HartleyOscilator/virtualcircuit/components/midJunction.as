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

	public class midJunction extends DynamicMovie {
		// Constants:
		// Public Properties:
		public var opp:Boolean;
		public var ids:String;
		public var jType:String;
		public var hit:Boolean;
		public var neighbours:Array;
		//public var jnc:Junction;
		public var pinType:String;
		public var isMidSnapped:Boolean;
		public var isHitWithRedPin:Boolean;
		public var isHitWithBlackPin:Boolean;
		//public var selectedJunc:Junction;
		public var pontMouseY:Number;
		var gf:GlowFilter;
		var prevX:Number;
		var prevY:Number;
		public var lastX:Number;
		public var lastY:Number;
				
		//public var crossedBound:Boolean;
		// Private Properties:

		// Initialization:

		//public function Junction(nam:String) {
		public function midJunction() {
			this.jType="midjunction";
			this.isHitWithRedPin=false;
			this.isHitWithBlackPin=false;
			this.buttonMode=true;
			//this.jnc=null;
			this.isMidSnapped=false;
			
			this.opp=false;
			this.hit=false;
			this.prevX=0;
			this.prevY=0;		
			this.neighbours=new Array();
			
			var mj=new MovieClip();
			mj.graphics.beginFill(0x000000);
			//mj.graphics.lineStyle(1,0xDDDDDD);
			mj.graphics.lineStyle(0);
			this.graphics.beginFill(0x000000);
			//this.graphics.lineStyle(1,0xDDDDDD);
			this.graphics.lineStyle(0);
			mj.alpha=0;
			this.alpha=0;
           
			mj.x=50;
			mj.y=50;

			this.x=0;
			this.y=0;

			mj.graphics.drawRect(-10,-10,15,15);
			this.graphics.drawRect(-10,-10,15,15);
			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,highlightMidJunction);
			this.addEventListener(MouseEvent.MOUSE_OUT,removeHighlightMidJunction);
			//this.addEventListener(MouseEvent.MOUSE_DOWN,drag);
			

		}
		function highlightMidJunction(e:MouseEvent):void{
			
			//this.alpha=0.1;
		
		}
		
		function removeHighlightMidJunction(e:MouseEvent):void{
			
			//this.filters=null;
			
			//this.alpha=0.1;
		
		}
		function changeColour(color:Number):void {
			var colorInfo:ColorTransform=this.transform.colorTransform;

			// Set a random color for the ColorTransform object.
			colorInfo.color=color;

			//Apply the random color for the rectangle
			this.transform.colorTransform=colorInfo;
		}
		
		
		function drag(e:MouseEvent):void {
			
			this.setSelection(true);

		}
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
		}
	}
	
		