package virtualcircuit.components {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.controls.TextArea;
	import virtualcircuit.logic.Circuit;
	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.LineChart;
	//import com.yahoo.astra.fl.charts.axes.NumericAxis;
	//import com.yahoo.astra.fl.managers.AlertManager;
	import flash.display.MovieClip;

	import com.yahoo.astra.fl.charts.series.LineSeries;
	
	public class GraphCRO extends CircuitComponent{
		
		// Constants:
		// Public Properties:
		//public var schematicComponent:SchematicCRO;
		public var realComponent:GraphCRO;
			//public var resistance:Number;
		//public var currText:TextField;
		//public var lineArray1:LineSeries; 
		// Private Properties:
	
		// Initialization:
		public function graphCRO() { 
			
			//super();
			
			this.schematicComponent=new GraphCRO();
			this.realComponent=new GraphCRO();
			//this.realComponent.scaleX=1/4;
			//this.realComponent.scaleY=1/4
			//this.schematicComponent.scaleX=1/4;
			//this.schematicComponent.scaleY=1/4;
			//this.resistance=0.0000000001;
			this.addChild(this.schematicComponent);
			this.addChild(this.realComponent);
			
			this.currText=new TextField();
			this.currText.width=40;
			this.currText.height=40;
			this.currText.y=-9.5;
			this.currText.x=-10;
			
			var timesNew=new TimesNew();
			var format:TextFormat = new TextFormat();
			format.font=timesNew.fontName;
			format.size = 11;
			format.align ="right";
			this.currText.defaultTextFormat = format;
			this.currText.setTextFormat(format);
			this.currText.embedFonts=true;
			this.currText.mouseEnabled=false;
			this.mouseEnabled=false;
			this.addChild(currText);
			
			var chartCategoryNames:Array=new Array();
			var chartDataProvider1:Array=new Array();
			var lineArray1:LineSeries = new LineSeries();
			
			var yArr=new Array(0,2,4,6,8,10,12,14);
			
			/*var mc=new MovieClip;
			this.addChild(mc);
			mc.width=this.width - this.width/3;
			mc.height=this.height - this.height/3;
			mc.x=this.x - this.width/2;
			mc.y=this.y - this.height/2;*/
			
			/*var dataChart=new LineChart();
			//this.addChild(dataChart);
			dataChart.mouseChildren=false;
			dataChart.x=this.x - this.width/3;
			dataChart.y=this.y - this.height/3;
			//trace(this.width - this.width/3,this.height - this.height/3)
			dataChart.width=this.width + this.width//- this.width/3;////mc.width
			dataChart.height=this.height + this.height//- this.height/3;*/		//mc.height
			
			
			/*for(var i=0;i<yArr.length;i++){
				root["yTxt"+i] = new TextField;
				root["yTxt"+i].text = yArr[i];
			}*/
			

		}
	
		// Public Methods:
		// Protected Methods:
				
		
		
	}
	
}