package virtualcircuit.userinterface{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.TextArea;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Junction;
	import virtualcircuit.components.NonContactAmmeter;
	import virtualcircuit.components.Voltmeter;
	import virtualcircuit.components.VoltPin;
	import virtualcircuit.logic.Circuit;
	import virtualcircuit.components.longWire;
	import virtualcircuit.components.midJunction;
	import virtualcircuit.components.GraphCRO;
	import com.yahoo.astra.fl.charts.LineChart;
	import com.yahoo.astra.fl.charts.series.LineSeries;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.external.*;
	import virtualcircuit.components.ICchip;
	import virtualcircuit.components.CROinput;
	import virtualcircuit.components.Comparator;
	import virtualcircuit.logic.SubCircuit;

	
	
	
	import fl.controls.CheckBox;
	import flash.geom.Rectangle;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Graphics;
	import flash.display;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.display.Sprite;
	import flash.geom.Transform;

	//import flash.utils.Timer;
	//import flash.events.TimerEvent;
	
	
	
	public class StageBuilder {

		// Constants:
		// Public Properties:

		// Private Properties:
		public static var componentBox:MovieClip;
		public static var nonContactObj:NonContactAmmeter;
		public static var nextNonContactObj:NonContactAmmeter;
		public static var voltmeterObj:Voltmeter;
		public static var nextVoltmeterObj:Voltmeter;
		static var ll:Radio=new Radio("Lifelike","Lifelike",-70,-25);
		static var tabbedPane:TabbedPane;
		static var wireScroll:Scroll;
		static var resistorScroll:Scroll;
		static var batteryScroll:Scroll;
		static var capasitorScroll:Scroll;
		static var rotationScroll:Scroll;
		static var sgFreScroll:Scroll;
		static var sgVoltScroll:Scroll;
		static var rb1:RadioButton;
		static var rb2:RadioButton;
		static var bulbScroll:MovieClip;
		static var diodeScroll:MovieClip;
		static var capacitorScroll:MovieClip;
		static var inductorScroll:MovieClip;
		static var powerRatingScroll:Scroll;
		static var voltageRatingScroll:Scroll;
		public static var triggerVol:Number;
		//static var triggerFreq:Number;
		public var mJunction:midJunction;
		public var m2Junction:midJunction;
		public var m3Junction:midJunction;
		public var m4Junction:midJunction;
		public var m5Junction:midJunction;
		public var m6Junction:midJunction;
		static var checkBox:CheckBox;
		static var polarity:CheckBox;
		public static var selectedObj:Object;
		public static var selectedJn:Junction;
		static var splitButton:Buttons;
		static var deleteButton1:Buttons;
		static var removeFromBoard:Buttons;
		static var deleteButton2:Buttons;
		static var showValuesButton:Buttons;
		static var deleteIcon:DeleteIcon;
		static var splitIcon:SplitIcon;
		var totGraphYPos=315;
  		 var totGraphXPos=-250;
		var labels:TextField = new TextField();
		var croShowButton:Button; 
		var circuitShowButton:Button;
		var resetButton:Button; 
		static var doc:TextArea;
		static var helpDoc:TextArea;
		static var isShowValues:Boolean=false;
		public static var hitNeed:Boolean;
		var voltObj:Voltmeter=new Voltmeter;
		var voltMeter:Voltmeter;
		// Initialization:
		public static var lWireObj1:Branch;
		public static var lWireObj2:Branch;
		public static var arr:Array;
		public static var croVisible:Boolean;
		public static var showBtn:Boolean;
		public static var showCicuit:Boolean;
		public static var croObj1:GraphCRO;
		var CROInputOb:Branch;
		var signalGeneratorObj:Branch;
		var dataChart=new LineChart();
		var lineArray1:LineSeries = new LineSeries();
		var chartCategoryNames:Array=new Array;
		var chartDataProvider:Array=new Array;
		public var V,C;
		var croArray:Array=new Array();
		
		var timer1:Timer=new Timer(1500);
		
		
		//variable for CRO Graph
		var graphOutLineClip:Graph2=new Graph2();
		var graphXfinal=295;
		var graphXinitial=50;
		var yInitial=5;
		var pointsX:Array=new Array();
		var pointsY:Array=new Array();
		var spike:Sprite = new Sprite();
		var pointsX1:Array=new Array();
		var pointsY1:Array=new Array();
		var spike1:Sprite = new Sprite();
		
		
		var spikeArray:Array=new Array();
		var voltperdiv_Array:Array=new Array(2,1,.5,.2,.1,.05,.02,.01,.005,20,10,5);
		var timeperdiv_Array:Array=new Array(200,100,50,20,10,5,2,1,.5,.2,.1,.05,.02,.01,.005,.002,.001,.0005);
		var cnt=0;
		var cnt2=0
		//-------------------------
		
		public function StageBuilder(rootMovie:MovieClip) {

			branchCount=0;
			junctionCount=0;
			componentBox=rootMovie;
			rootMovie.boundArea.addEventListener(MouseEvent.MOUSE_UP,removeSelected);
			
			doc=new TextArea();
			doc.width=rootMovie.boundArea.width-20;
			doc.height=rootMovie.boundArea.height-20;
			doc.x=rootMovie.boundArea.x-rootMovie.boundArea.width;
			doc.y=rootMovie.boundArea.y-rootMovie.boundArea.height-75;
			doc.visible=false;
			doc.editable=false;
			loadDocText();
			rootMovie.boundArea.addChild(doc);
			
						
			helpDoc=new TextArea();
			helpDoc.width=rootMovie.boundArea.width-20;
			helpDoc.height=rootMovie.boundArea.height-20;
			helpDoc.x=rootMovie.boundArea.x-rootMovie.boundArea.width;
			helpDoc.y=rootMovie.boundArea.y-rootMovie.boundArea.height-75;
			helpDoc.visible=false;
			helpDoc.editable=false;
			loadHelpDocText();
			rootMovie.boundArea.addChild(helpDoc);
			
			componentBox.boundArea.addChild(labels);
			labels.selectable=false;
			
			this.loadComponents();
	
		}

		// Public Methods:
		
		// Protected Methods:
		/*
		Performs initial setting up of the stage.
		Keeps all the components in the pallete and
		add all required listeners to them.
		*/
		function loadDocText(){
			
			doc.htmlText=<html>
			<b>Theory</b>
			<b><u>Objective</u></b>
			To learn how to build and run an electrical circuit. 
			  To measure current and voltageanywhere in the circuit. 
			  To determine the relationships between Current, Voltage and Resistance.
			
			<b><u>Theory</u></b>
			The following summarizes the basic theory behind DC electrical circuits:
			
			<b><u>Electric Potential</u></b>
			The electric field E is related to the rate of change of electric potential V.
			  If the electric potential changes by the amount del.V , the electric field in the 
			  direction of the displacement is: E= (-)del.V/del.s
			
			<b><u>Current</u></b>
			Current I is defined as the flow of charge Q per until time:
				 I= del.Q / del.t
			
			<b><u>Power</u></b>
			Power P is the rate of energy flow per unit time through a circuit or circuit element:
				 P=VI
			
			<b><u>Ohms Law</u></b>
			For many a material, the current I through it is proportional to the potential
			  difference across it,with the resistance R being the constant of proportionality,
			  as well as the slope of the V vs. I graph:
				  V = IR
			  Materials that behave this law are known as ohmic materials; those that do not 
			  are non-ohmic.
			<b><u>Kirchoffs Junction Rule</u></b>
			The current entering any point in a circuit must equal the current leaving that 
			  point. This ensures that there is no charge buildup anywhere, which would violate 
			  conservation of charge and energy.
			
			</html>;
		}
		

		function loadHelpDocText(){
			
			helpDoc.htmlText=<html>
			
			<b>User Manual</b>
			
			<b><u>Hints and Tips</u></b>
			
1.	All components are provided at the components panel, which is on the right, you may drag the required component from it.
2.	Except for Voltmeter and Non Contact Ammeter, all other components will be duplicated on the components panel, when you drag it and place it on the area provided.  
3.	You can place the Voltmeter and Non Contact Ammeter back in their earlier positions, i.e. in the components panel, after their use.
4.	A wire is required to connect any two components. The connection can be done by dragging the junction (the circle at the either end of each component) of a wire onto the junction of a component.
5.	Double Click anywhere on the switch to open or close it.
6.	To measure the voltage between two junctions use the voltmeter. Place the Red Pin one junction and the Black Pin on the other junction. The voltage will be displayed on the display of the Voltmeter.
7.	To measure current you can either use a non contact ammeter or an ammeter. Using a non contact ammeter you can measure the current by placing it over any point on the circuit. When using an ammeter you have to connect it to the circuit,like any other component, but always in series to measure the current.
8.	To reset the entire circuit go to circuit tab and click the reset button.
9.	You can switch between two views Lifelike and Schematic by selecting the appropriate radio button from the Visual Tab.
10.	When you click on a Resistor, Wire, Bulb or Battery the properties of the respective components, such as resistance for resistor and voltage for battery etc, are shown on the advanced tab below. The text box indicates the current value of the property.  By default the 
					-	Resistance of a resistor is 10 ohms.
					-	 Resistance of a bulb is 10 ohms.
					-	Resistivity of a wire is 0.01 ohms.
					-	Voltage of a battery is 10 volts.
You can change the value by either inserting the desired value in the text box or by using the slider.  By selecting the All check box you change the values of all the objects of that particular component.  The ranges between which you can vary each of the property are: -
					-	Resistance of a resistor 
					-	Resistance of a bulb
					-	Resistivity of a wire
					-	Voltage of a battery 
			
			</html>;
		}
		
		var mJunctionCount;
		var mJunctionArr:Array;
		function loadComponents():void {
			
			  
			  //CRO Graph
			    var posX=componentBox.x+80;
				var posY=componentBox.y+410;
				componentBox.addChild(spike);
				/*graphOutLineClip.addChild(spike);
				graphOutLineClip.addChild(spike1);
				graphOutLineClip.x=posX;
				graphOutLineClip.y=posY;
				graphOutLineClip.width=230;
				graphOutLineClip.height=200;
				graphOutLineClip.visible=false;*/
			 ////----------------- 
			  
			/*var ICchipObj:Branch=new Branch("ICchip");
			ICchipObj.scaleX=0.65;
			ICchipObj.scaleY=0.55;
			ICchipObj.setPrev(600,270);
			ICchipObj.setPos();
			ICchipObj.startJunction.visible=false;
			ICchipObj.endJunction.visible=false;
			componentBox.addChild(ICchipObj);
			//trace(ICchipObj.width,ICchipObj.height)
			ICchipObj.addEventListener(MouseEvent.MOUSE_UP,addICchipToStage);
			Circuit.addBranchToList(ICchipObj);*/
			
			componentBox.circuitMC.visible=false;
			
			
			
			//var batteryOb:Branch=new Branch("battery");
			//batteryOb.scaleX=0.6;
			//batteryOb.scaleY=0.6;
			//batteryOb.setPrev(150,200);
			//batteryOb.setPos();
			//batteryObj.startJunction.visible=false;
			//batteryObj.endJunction.visible=false;
			//componentBox.addChild(batteryOb);
			//batteryObj.addEventListener(MouseEvent.MOUSE_UP,addBatteryToStage);
			//Circuit.addComponent(batteryOb);
			//Circuit.addBranchToList(batteryOb);
			
			
			
			
			/*var wireOb1:Branch=new Branch("wire");
			wireOb1.scaleX=0.6;
			wireOb1.scaleY=0.6;
			wireOb1.setPrev(200,350);
			wireOb1.setPos();*/
			//wireObj.startJunction.visible=false;
			//wireObj.endJunction.visible=false;
			//componentBox.addChild(wireOb1);
			//wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
			//Circuit.addComponent(wireOb1);
			//Circuit.addBranchToList(wireOb1);
			var transistorObj:Branch=new Branch("Transistor");
			transistorObj.scaleX=0.60;
			transistorObj.scaleY=0.60;
			transistorObj.setPrev(640,129);
			transistorObj.setPos();
			transistorObj.startJunction.visible=false;
					transistorObj.endJunction.visible=false;
					transistorObj.baseJunction.visible=false;
			componentBox.addChild(transistorObj);
			transistorObj.addEventListener(MouseEvent.MOUSE_UP,addTransistorToStage);
			Circuit.addBranchToList(transistorObj);
			
			var transistorBaseObj:Branch=new Branch("TransistorBaseJunction");
			transistorBaseObj.scaleX=0.65;
			transistorBaseObj.scaleY=0.55;
			transistorBaseObj.setPrev(750,265);
			transistorBaseObj.setPos();
			transistorBaseObj.startJunction.visible=false;
			transistorBaseObj.endJunction.visible=false;
			//transistorObj.baseJunction.visible=false;
			//componentBox.addChild(transistorBaseObj);
			//transistorBaseObj.addEventListener(MouseEvent.MOUSE_UP,addTransistorToStage);
			Circuit.addBranchToList(transistorBaseObj);
			
			
			///var bulbOb:Branch=new Branch("bulb");
			///bulbOb.scaleX=0.65;
			//bulbOb.scaleY=0.55;
			//bulbOb.setPrev(280,350);
			//bulbOb.setPos();
			//bulbObj.startJunction.visible=false;
			//bulbObj.endJunction.visible=false;
			//componentBox.addChild(bulbOb);
			//bulbObj.addEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
			//Circuit.addComponent(bulbOb);
			//Circuit.addBranchToList(bulbOb);
			
			/*var wireOb:Branch=new Branch("wire");
			wireOb.scaleX=0.6;
			wireOb.scaleY=0.6;
			wireOb.setPrev(330,430);
			wireOb.setPos();
			//wireObj.startJunction.visible=false;
			//wireObj.endJunction.visible=false;
			componentBox.addChild(wireOb);
			wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
			//wireOb.setChildIndex(wireOb,wireOb.parent.numChildren-1);
			Circuit.addComponent(wireOb);
			Circuit.addBranchToList(wireOb);*/
			
			 CROInputOb=new Branch("CROinputTerminal");
			CROInputOb.scaleX=1.2;
			CROInputOb.scaleY=.6;
			CROInputOb.setPrev(265,530);
			//CROInputOb.width=300;
			CROInputOb.startJunction.visible=true;
			CROInputOb.endJunction.visible=true;
			CROInputOb.startJunction.scaleX=.6
			CROInputOb.endJunction.scaleX=.6
			CROInputOb.startJunction.x=CROInputOb.startJunction.x+7;
			CROInputOb.startJunction.y=CROInputOb.startJunction.y-4;
			CROInputOb.endJunction.x=CROInputOb.endJunction.x-7;
			CROInputOb.endJunction.y=CROInputOb.endJunction.y-3;
			CROInputOb.setPos();
			componentBox.addChild(CROInputOb);
		    Circuit.addComponent(CROInputOb);			
			Circuit.addBranchToList(CROInputOb);
			Circuit.circuitAlgorithm();
			
			//var comparatorObj:Branch=new Branch("comparator");
			//comparatorObj.scaleX=0.60;
			//comparatorObj.scaleY=0.60;
			//comparatorObj.setPrev(328,165);
			//comparatorObj.setPos();
			//comparatorObj.startJunction.visible=false;
			//comparatorObj.endJunction.visible=false;
			//componentBox.addChild(comparatorObj);
			//comparatorObj.addEventListener(MouseEvent.MOUSE_UP,addSwitchToStage);
			//Circuit.addComponent(comparatorObj);
			//Circuit.addBranchToList(comparatorObj);
			
			var jn:Junction=new Junction();					
			
			//woring.........
			//jn.boardHitJunction(batteryOb.endJunction,wireOb1.startJunction);
			//jn.boardHitJunction(wireOb1.endJunction,bulbOb.startJunction);
			//jn.boardHitJunction(bulbOb.endJunction,batteryOb.startJunction);
			//working.........
			
			
			//woring.........
			//jn.boardHitJunction(wireOb.endJunction,batteryOb.startJunction);
			//jn.boardHitJunction(batteryOb.endJunction,wireOb1.startJunction);
			//jn.boardHitJunction(wireOb1.endJunction,wireOb.startJunction);
			//working.........
			
			var comparator:Comparator=new Comparator;
			trace(comparator.referenceVoltage)
			
			//jn.boardHitJunction(batteryOb.endJunction,comparatorObj.startJunction);
			//jn.boardHitJunction(comparatorObj.endJunction,bulbOb.startJunction);
			//jn.boardHitJunction(bulbOb.endJunction,batteryOb.startJunction);
			
			
			//jn.boardHitJunction(batteryOb.endJunction,bulbOb.startJunction);
			//Circuit.circuitAlgorithm();
			
					
			
			
			/*var switchObj:Branch=new Branch("switch");
			switchObj.scaleX=0.60;
			switchObj.scaleY=0.60;
			switchObj.setPrev(628,165);
			switchObj.setPos();
			switchObj.startJunction.visible=false;
			switchObj.endJunction.visible=false;
			componentBox.addChild(switchObj);
			switchObj.addEventListener(MouseEvent.MOUSE_UP,addSwitchToStage);
			Circuit.addBranchToList(switchObj);*/
        
		
			/*var bulbObj:Branch=new Branch("bulb");
			bulbObj.scaleX=0.65;
			bulbObj.scaleY=0.55;
			bulbObj.setPrev(723,140);
			bulbObj.setPos();
			bulbObj.startJunction.visible=false;
			bulbObj.endJunction.visible=false;
			componentBox.addChild(bulbObj);
			bulbObj.addEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
			Circuit.addBranchToList(bulbObj);
			
			var nextNonContactObj=new NonContactAmmeter();
			nonContactObj=nextNonContactObj;
			nextNonContactObj.scaleX=0.35;
			nextNonContactObj.scaleY=0.35;
			//nextNonContactObj.setPrev(615,165);
			nextNonContactObj.setPos();
			componentBox.addChild(nextNonContactObj);
			nextNonContactObj.addEventListener(MouseEvent.CLICK,changeScroll);
			nextNonContactObj.addEventListener(MouseEvent.MOUSE_UP,addNonContactAmmeterToStage);*/
			
			var resistorObj:Branch=new Branch("resistor");
			resistorObj.scaleX=0.55;
			resistorObj.scaleY=0.55;
			resistorObj.setPrev(713,132);
			resistorObj.setPos();
			resistorObj.startJunction.visible=false;
			resistorObj.endJunction.visible=false;
			componentBox.addChild(resistorObj);
			resistorObj.addEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
			Circuit.addBranchToList(resistorObj);
			//resistorObj.rotation=90;
			
			/*var DiodeObj:Branch=new Branch("diode");
			DiodeObj.scaleX=0.5;
			DiodeObj.scaleY=0.6;
			DiodeObj.setPrev(635,230);
			DiodeObj.setPos();
			DiodeObj.startJunction.visible=false;
			DiodeObj.endJunction.visible=false;
			componentBox.addChild(DiodeObj);
			DiodeObj.addEventListener(MouseEvent.MOUSE_UP,addDiodeToStage);
			Circuit.addBranchToList(DiodeObj);	
           
			var ammeterObj:Branch=new Branch("ammeter");
			ammeterObj.scaleX=0.75;
			ammeterObj.scaleY=0.75;
			ammeterObj.setPrev(707,321);
			ammeterObj.setPos();
			ammeterObj.startJunction.visible=false;
			ammeterObj.endJunction.visible=false;
			componentBox.addChild(ammeterObj);
			ammeterObj.addEventListener(MouseEvent.MOUSE_UP,addAmmeterToStage);
			Circuit.addBranchToList(ammeterObj);*/
			
			/*var croObj:Branch=new Branch("cro");
			//croObj.scaleX=0.75;
			//croObj.scaleY=0.75;
			croObj.setPrev(707,365);
			croObj.setPos();
			croObj.startJunction.visible=false;
			croObj.endJunction.visible=false;
			componentBox.addChild(croObj);
			croObj.addEventListener(MouseEvent.MOUSE_UP,addCroToStage);
			Circuit.addBranchToList(croObj);*/

			var wireObj:Branch=new Branch("wire");
			wireObj.scaleX=0.6;
			wireObj.scaleY=0.6;
			wireObj.setPrev(715,190);
			wireObj.setPos();
			wireObj.startJunction.visible=false;
			wireObj.endJunction.visible=false;
			componentBox.addChild(wireObj);
			//componentBox.setChildIndex(wireObj,componentBox.numChildren-1);
			wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
			Circuit.addBranchToList(wireObj);
			
			
			var capacitorObj:Branch=new Branch("capacitorNew");			
			capacitorObj.scaleX=0.6;
			capacitorObj.scaleY=0.6;
			capacitorObj.setPrev(645,198);
			capacitorObj.setPos();
			capacitorObj.startJunction.visible=false;
			capacitorObj.endJunction.visible=false;
			componentBox.addChild(capacitorObj);
			capacitorObj.addEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
			Circuit.addBranchToList(capacitorObj);
			
			/*signalGeneratorObj=new Branch("signalGenerator");
			signalGeneratorObj.scaleX=1.2;
			signalGeneratorObj.scaleY=.6;
			signalGeneratorObj.setPrev(95,530);
			//CROInputOb.width=300;
			signalGeneratorObj.startJunction.visible=true;
			signalGeneratorObj.endJunction.visible=true;
			signalGeneratorObj.startJunction.scaleX=.6
			signalGeneratorObj.endJunction.scaleX=.6
			signalGeneratorObj.startJunction.x=signalGeneratorObj.startJunction.x+9;
			signalGeneratorObj.startJunction.y=signalGeneratorObj.startJunction.y-3.5;
			signalGeneratorObj.endJunction.x=signalGeneratorObj.endJunction.x-7;
			signalGeneratorObj.endJunction.y=signalGeneratorObj.endJunction.y-3;
			//signalGeneratorObj.startJunction.scaleY=.6
			//signalGeneratorObj.endJunction.scaleY=.4
			signalGeneratorObj.setPos();
			
			componentBox.addChild(signalGeneratorObj);
		    Circuit.addComponent(signalGeneratorObj);			
			Circuit.addBranchToList(signalGeneratorObj);*/
			//Circuit.circuitAlgorithm();
			
			
			var inductorObj:Branch=new Branch("inductor");
			inductorObj.scaleX=0.55;
			inductorObj.scaleY=0.7;
			inductorObj.setPrev(720,229);
			inductorObj.setPos();
			inductorObj.startJunction.visible=false;
			inductorObj.endJunction.visible=false;
			componentBox.addChild(inductorObj);
			inductorObj.addEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
			Circuit.addBranchToList(inductorObj);			
		  
			/*var nextVoltmeterObj=new Voltmeter();
			voltmeterObj=nextVoltmeterObj;
			nextVoltmeterObj.volt.scaleX=0.55;
			nextVoltmeterObj.volt.scaleY=0.55;
			componentBox.addChild(nextVoltmeterObj);
			nextVoltmeterObj.addEventListener(MouseEvent.MOUSE_UP,addVoltmeterToStage);
			nextVoltmeterObj.addEventListener(MouseEvent.CLICK,changeScroll);
			nextVoltmeterObj.setupVoltmeter();*/
			
			
			var batteryObj:Branch=new Branch("battery");
			batteryObj.scaleX=0.6;
			batteryObj.scaleY=0.6;
			batteryObj.setPrev(629,230);
			batteryObj.setPos();
			batteryObj.startJunction.visible=false;
			batteryObj.endJunction.visible=false;
			componentBox.addChild(batteryObj);
			batteryObj.addEventListener(MouseEvent.MOUSE_UP,addBatteryToStage);
			Circuit.addBranchToList(batteryObj);			
	
			ll.selected=true;
			ll.resetVal(ll.value);
			
			/*var wireObj1:Branch=new Branch("wire");
			wireObj1.scaleX=0.6;
			wireObj1.scaleY=0.6;
			wireObj1.setPrev(715,435);
			wireObj1.setPos();
			//wireObj.startJunction.visible=false;
			//wireObj.endJunction.visible=false;
			componentBox.addChild(wireObj1);
			wireObj1.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
			Circuit.addBranchToList(wireObj1);*/
			
			/*var jun:Junction=new Junction();					
			jun.boardHitJunction(batteryObj.endJunction,wireObj1.startJunction);
			jun.boardHitJunction(wireObj1.endJunction,bulbObj.startJunction);
			jun.boardHitJunction(bulbObj.endJunction,wireObj.startJunction);
			jun.boardHitJunction(wireObj.endJunction,batteryObj.startJunction);*/
			/*
			croObj1=new GraphCRO;
			croObj1.x = componentBox.x + componentBox.width/4.7;
			croObj1.y = componentBox.y + componentBox.height/2.25;
			//croObj1.width=600;
			croObj1.mask=componentBox.boundArea.boundArea.croMask
			componentBox.addChild(croObj1);
			*/
			
			
			
			//croObj1.addChild(dataChart);
			//dataChart=new LineChart();
			//componentBox.addChild(dataChart);
			//dataChart.visible=false;
			//dataChart.x = croObj1.x - croObj1.width/1.11;
			//dataChart.y = croObj1.y - croObj1.height/0.97;
			//dataChart.setStyle("backgroundSkin", CustomBackgroundSkin);
			//dataChart.setStyle("seriesColors", [0x00FFFF]);
			//componentBox.setChildIndex(dataChart,componentBox.numChildren-1);
			componentBox.CRO.visible=false;
			componentBox.CRO.mask=componentBox.boundArea.boundArea.croMask
			//Button for showing CRO
			croShowButton = new Button();
			croShowButton.y=500;
			croShowButton.x=652;
			croShowButton.buttonMode=true;
			componentBox.addChild(croShowButton);
			croShowButton.label="Show CRO";
			croShowButton.addEventListener(MouseEvent.CLICK,showBtnClicked);
			
			//Button for showing correct Circuit
			circuitShowButton = new Button();
			circuitShowButton.y=474;
			circuitShowButton.x=652;
			circuitShowButton.buttonMode=true;
			componentBox.addChild(circuitShowButton);
			circuitShowButton.label="Show Circuit";
			circuitShowButton.addEventListener(MouseEvent.CLICK,showCircuit);
			//componentBox.addEventListener(MouseEvent.MOUSE_UP,removeEnterFrameExecution);
			
			resetButton = new Button();
			resetButton.y=550;
			resetButton.x=695;
			resetButton.width=65;
			resetButton.height=20;
			resetButton.buttonMode=true;
			componentBox.addChild(resetButton);
			resetButton.label="Reset";
			resetButton.addEventListener(MouseEvent.CLICK,resetFN);
			
			var yPos=160;
			var IwireArr:Array=new Array();
			
			for(var i=0;i<62;i++){
				 var lWireObj:Branch = new Branch("longWire");
				 lWireObj.name="longWire"+i;
				Circuit.longWireArray.push(lWireObj);				
				lWireObj.setPrev(80,yPos);				
				lWireObj.setPos();
				lWireObj.startJunction.visible=false;
				lWireObj.endJunction.visible=false;
				lWireObj.startJunction.width=20;				
				componentBox.addChild(lWireObj);
			    componentBox.setChildIndex(lWireObj,componentBox.numChildren-1);
				mJunctionArr=new Array();
				this.mJunction=new midJunction();
			//Positioning the first junction in each wire object
				if ((i>3) && (i<33)){
					mJunctionCount=5;				
					/*if(i==4){
					this.mJunction.x=this.mJunction.x+6+(i*2)-22;	
					}else{*/
						this.mJunction.x=this.mJunction.x+6+(i*2)+(15*(i-5.6));	
					//}
					this.mJunction.y=this.mJunction.y-245;				
				
				}else if (i>=33){
				 mJunctionCount=5;				 
				 this.mJunction.y=this.mJunction.y-135;
				 this.mJunction.x=this.mJunction.x+6+(i*2)+(15*(i-38.5));					//(10+(15*(i-35)));		
								
				}
				else{
					 mJunctionCount=29;				 
					 this.mJunction.x=this.mJunction.x-10;				
					 this.mJunction.y=this.mJunction.y+10
					 if(i>=2){
						 this.mJunction.y=this.mJunction.y+10; 
					 }
					 //this.mJunction.visible=false;
				}
			
			mJunctionArr.push(this.mJunction);			
			lWireObj.addChild(mJunction);
			//mJunction.parent.setChildIndex(mJunction,mJunction.parent.numChildren-1);
			//lWireObj.setChildIndex(lWireObj,lWireObj.numChildren-1);
			
			//POsitioning the junctions
			for(var j=1;j<mJunctionCount;j++){				
				this.m2Junction=new midJunction();
				mJunctionArr.push(this.m2Junction);
				//mJunction.x=e.target.parent.parent.startJunction.x-=e.target.parent.parent.startJunction.width/2;
				lWireObj.addChild(m2Junction);
				/*if(i==0 && j==2){
					this.m2Junction.alpha=1;
					this.m2Junction.
				}*/
				if ((i>3)){
					if (j==1){							
						
						m2Junction.y=mJunctionArr[0].y+18;
						//mJunctionArr[0].alpha=1;
							
					}else{					
						m2Junction.y=mJunctionArr[j-1].y+18;
						
					}
					m2Junction.x=mJunctionArr[0].x;
					
					m2Junction.parent.setChildIndex(m2Junction,m2Junction.parent.numChildren-1);
					//m2Junction.visible=false;
				}
				else{
							
					m2Junction.x=mJunctionArr[j-1].x+17;
					this.m2Junction.y=this.m2Junction.y+10
					 if(j==5 || j==11 || j==17 || j==23){
						m2Junction.visible=false; 
					 }
					if(i>=2){
						this.m2Junction.y=this.m2Junction.y+10;
						
					}
					m2Junction.parent.setChildIndex(m2Junction,m2Junction.parent.numChildren-1);
					//m2Junction.visible=false;
				}
			
			}
			
			//Positioning the wire oibject
			if (i==1){
				yPos=yPos+264;
			}
			else if (i<4){
				yPos=yPos+18;
			
				}
			}
			componentBox.setChildIndex(wireObj,componentBox.numChildren-1);
			timer1.addEventListener(TimerEvent.TIMER,timer1_Fn);
			    componentBox.CRO.knobV_total.volt_left.addEventListener(MouseEvent.MOUSE_DOWN,volt_left_FN);
				componentBox.CRO.knobV_total.volt_right.addEventListener(MouseEvent.MOUSE_DOWN,volt_right_FN);
				componentBox.CRO.knobT_total.time_left.addEventListener(MouseEvent.MOUSE_DOWN,time_left_FN);
				componentBox.CRO.knobT_total.time_right.addEventListener(MouseEvent.MOUSE_DOWN,time_right_FN);
				componentBox.CRO.graphVerticalKnob.Right.addEventListener(MouseEvent.MOUSE_DOWN,moveGraphUp);
				componentBox.CRO.graphVerticalKnob.Left.addEventListener(MouseEvent.MOUSE_DOWN,moveGraphDown);
				componentBox.CRO.graphHoriKnob.Right.addEventListener(MouseEvent.MOUSE_DOWN,moveGraphRight);
				componentBox.CRO.graphHoriKnob.Left.addEventListener(MouseEvent.MOUSE_DOWN,moveGraphLeft);
				componentBox.CRO.graphVerticalKnob.tuner.gotoAndStop(76);
				componentBox.CRO.graphHoriKnob.tuner.gotoAndStop(1);
				componentBox.CRO.knobV_total.turner_volt.gotoAndStop(6);		
				componentBox.CRO.knobT_total.turner_time.gotoAndStop(9)
		  // Circuit.circuitAlgorithm();
		//	trace(Circuit.longWireArray)
		componentBox.boundArea.boundArea.mask_clip1.x=componentBox.boundArea.boundArea.mask_clip1.x+2;
		componentBox.boundArea.boundArea.mask_clip.x=componentBox.boundArea.boundArea.mask_clip.x+2;
		componentBox.diagramMC.mask=componentBox.digramMask;
		componentBox.diagramMC.visible=false;
			
		//}
	}
		var mkk=0;
		function outpt_Wave(graphScaleX:Number,graphScaleY:Number){
			//Resltant_Volt()
			//Output_Freq()
			//var res1=1000;
			//var res2=1000;
			var res1=SubCircuit.res1;
			var res2=SubCircuit.res2;
			//res1=res1*graphScaleX;
			//res2=res2*gra3phScaleX;
			//var cap1=0.1;
			//var cap2=0.1;
			var cap1=SubCircuit.cap1;
			var cap2=SubCircuit.cap2;
			var inductorLength=SubCircuit.inductance1*10;
			var time1= 0.69*res1*cap1;
			var time2= 0.69*res2*cap2;
			////trace("time1--"+time1);
			//trace("time2--"+time2);
			//time1=time1*10;
			//time2=time2*10;
			//time1=(Math.round(time1*1000)/1000)*1000
			//time2=(Math.round(time2*1000)/1000)*1000
			//trace("time1--"+time1);
			//trace("time2--"+time2);
			//time1=time1*graphScaleX;
			//time2=time2*graphScaleX;
			var forTime1=true;
			var forTime2=false;
			var time=time1;
			var timeString="firstTime";
			var graphchange:Boolean;
			var count=600;
			var graphCount=0;
			var xPos=0;
			//SubCircuit.icVoltOut=8;
			var minVolt=0;
			var maxVolt=0;
			var frequency=0;
			
			//SubCircuit.circuiteOk=true;
			trace("SubCircuit.icVoltOut="+SubCircuit.icVoltOut);
			if(SubCircuit.circuiteOk==true){
			//triggerVol=sgVoltScroll.slider.value;
			 if(SubCircuit.icVoltOut>0){
				SubCircuit.icVoltOut=batteryScroll.slider.value;
				
			 }
			  if(SubCircuit.icVoltOut<0){
				SubCircuit.icVoltOut=batteryScroll.slider.value*-1; 
			 }
			minVolt=SubCircuit.icVoltOut*res2/(res2+res1);
			maxVolt=SubCircuit.icVoltOut-((SubCircuit.icVoltOut-6)/(res1+res2))*res1;
			// frequency=1/Math.pow(2*3.14*(cap1*cap2*Math.pow(10,-6)*inductorLength/(cap1+cap2)) ,0.5);
			frequency=1/(2*3.14*(Math.pow(cap1*cap2*inductorLength/(cap1+cap2),0.5)));
			}else{
				if(SubCircuit.icVoltOut>0){
				//SubCircuit.icVoltOut=batteryScroll.slider.value;
				
					 }else{
						SubCircuit.icVoltOut=0; 
					 }
			}
			trace("minVolt=="+minVolt+"--MaxVolt=="+maxVolt+"-frequency=="+frequency+"-amplitude=="+(maxVolt-minVolt));
			
			pointsX.splice(0,pointsX.length);
			pointsY.splice(0,pointsY.length);
			pointsX1.splice(0,pointsX1.length);
			pointsY1.splice(0,pointsY1.length);
			spike.graphics.clear();
			if(SubCircuit.icVoltOut>0 && SubCircuit.circuiteOk==true ){	
				X1=0;
				
				var t1=0
				for(var i=0;i*ghXScale<=count ;){
					pointsX.push(i*ghXScale);
					var pointY=(minVolt+maxVolt)/2-(maxVolt-minVolt)*Math.sin(2*3.14*frequency*i)/2;
					pointsY.push(pointY*ghYScale);
					i=i+.2;
					if(i==0.2 && i*ghXScale>=count){
						count= i*ghXScale;
					}
					
				}
			}else{
				for(var i=0;i*ghXScale<=count ;){
					pointsX.push(i*ghXScale);
					var pointY=SubCircuit.icVoltOut*-1;
					pointsY.push(pointY*ghYScale);
					i=i+.5;
					if(i==0.5 && i*ghXScale>=count){
						count= i*ghXScale;
					}
					
				}
			}
			spike.graphics.clear();
				spike.graphics.lineStyle(2,0x009900);
				for(var i=0;i<pointsX.length;i++){
					spike.y=totGraphYPos;
					spike.graphics.lineTo(pointsX[i],pointsY[i]);
								
				}
				
											trace("pointsX--"+pointsX);
											trace("spike.width-"+spike.width);
											trace("pointsX--"+pointsY);
			if(SubCircuit.icVoltOut>0 && SubCircuit.circuiteOk==true ){
				spike.y=totGraphYPos-pointsY[0];
			}else{
				spike.y=totGraphYPos;
			}
			
			
			spike.x=totGraphXPos;
			//trace("spike.y="+spike.y+"--height ="+spike.height+"----"+spike.scaleY+"-time-"+1/frequency);
			
			
		
		}
		
		
		
		
		
		
		function removeEnterFrameExecution(e:MouseEvent){
			var hitJunc:Junction=new Junction();
		//trace("*******--"+e.target.dropTarget);
		//hitJunc.removeEnterFrameExecution(e.target,e.target.dropTarget);
			e.target.removeEventListener(Event.ENTER_FRAME,hitJunc.hitOnJunction);
		}
		var ghXScale=10;
		var ghYScale=2;
		var prvYscale=0;
		function showBtnClicked(e:MouseEvent){
			//voltMeter=new Voltmeter;
			//trace("text***  "+voltMeter.volt.currText.text)
			showBtn = showBtn ? false:true;
			//trace(V,C)
			//timer1.addEventListener(TimerEvent.TIMER,timer1_Fn);
			if(showBtn){
				resistorScroll.slider.enabled=false;
				batteryScroll.slider.enabled=false;
				capasitorScroll.slider.enabled=false;
				inductorScroll.slider.enabled=false;
				rotationScroll.slider.enabled=false;
				componentBox.CRO.visible=true;
				componentBox.setChildIndex(componentBox.CRO,componentBox.numChildren-1);
				croVisible=true;
				dataChart.visible==true;
				componentBox.boundArea.boundArea.total_mc.visible=false;
				spike.visible=true;
				spike.mask=componentBox.boundArea.boundArea.mask_clip;
				spike1.visible=true;
				outpt_Wave(ghXScale,ghYScale);
				
				deleteButton1.enabled=false;
				removeFromBoard.enabled=false;
				circuitShowButton.enabled=false;

				componentBox.setChildIndex(spike,componentBox.numChildren-1);
				componentBox.CRO.graphBaseLines.mask=componentBox.boundArea.boundArea.mask_clip1;
				croShowButton.label="Hide CRO";
				
			}
			else{
				componentBox.CRO.visible=false;
				spike.visible=false;
				spike1.visible=false;
				croVisible=false;
				deleteButton1.enabled=true;
				removeFromBoard.enabled=true;
				circuitShowButton.enabled=true;
				componentBox.boundArea.boundArea.total_mc.visible=true;
				croShowButton.label="Show CRO";
			}
		}
		 function showCircuit(e:MouseEvent){
			
			showCicuit = showCicuit ? false:true;
			if(showCicuit){
				//componentBox.setChildIndex(componentBox.circuitMC,componentBox.numChildren-1);
				//componentBox.setChildIndex(componentBox.diagramMC,componentBox.numChildren-1);
				//componentBox.circuitMC.visible=true;
				if(rb2.selected==true){
					
					componentBox.diagramMC.visible=true;
					componentBox.diagramMC.mask=componentBox.digramMask;
					componentBox.setChildIndex(componentBox.diagramMC,componentBox.numChildren-1);
				}else{
					
					componentBox.circuitMC.visible=true;
					componentBox.circuitMC.mask=componentBox.digramMask;
					componentBox.setChildIndex(componentBox.circuitMC,componentBox.numChildren-1);
				}
				circuitShowButton.label="Hide Circuit";
				CROInputOb.visible =false;
				croShowButton.visible=false;
				deleteButton1.visible=false;
				resetButton.visible=false;
				removeFromBoard.visible=false;
				rb1.visible=true;
				rb2.visible=true;
			}else{
				componentBox.circuitMC.visible=false;
				componentBox.diagramMC.visible=false;
				circuitShowButton.label="Show Circuit";
				CROInputOb.visible =true;
				croShowButton.visible=true;
				deleteButton1.visible=true;
				removeFromBoard.visible=true;
				resetButton.visible=true;
				rb1.visible=false;
				rb2.visible=false;
			}
		}
		function timer1_Fn(e:TimerEvent){
			V = SubCircuit.icVoltOut;			//ICchip.getVolt();
			C =SubCircuit.icCurrOut; 			//ICchip.getCurr();
			trace(dataChart.parent)
			if(!isNaN(V)){
				if(dataChart.parent!=null){
					trace('enterr')
					componentBox.removeChild(dataChart);
				}
				dataChart=new LineChart();
				/*if(croVisible){
					dataChart.visible=true;
				} else{
					dataChart.visible=false;
				}*/
				croArray.push(V);
				//trace("V.. "+V)
				chartCategoryNames.push(croArray.length)
				chartDataProvider.push(croArray[croArray.length-1]);
				fn(dataChart);
			}
		}
		
		public function fn(obj2:LineChart){//public static function fn(obj:Voltmeter,obj2:LineChart){
			dataChart=obj2;
			trace(showBtn)
			if(!showBtn){
				timer1.stop();
				timer1.reset();
				//chartCategoryNames=new Array;
				//chartDataProvider=new Array;
			}
			/*if(showBtn){
				componentBox.setChildIndex(croObj1,componentBox.numChildren-1);
				dataChart.visible=true;
				componentBox.boundArea.boundArea.total_mc.visible=false;
				croVisible=true;
				croObj1.visible=true;
			} else{
				componentBox.boundArea.boundArea.total_mc.visible=true;
				dataChart.visible=false;
				croVisible=false;
				croObj1.visible=false;
			}*/
			else{
				lineArray1=new LineSeries;
				dataChart.setStyle("backgroundSkin", CustomBackgroundSkin);
				dataChart.setStyle("seriesColors", [0xc82d24]);
				if(dataChart.parent!=null){
					trace('removee')
					componentBox.removeChild(dataChart);
				}
				//if(showBtn)
					componentBox.addChild(dataChart);
					trace('addchild')
				lineArray1.dataProvider = chartDataProvider;
				dataChart.categoryNames = chartCategoryNames;
				dataChart.dataProvider = [lineArray1];
				dataChart.x = 125;
				dataChart.y = 180;
				dataChart.width=370;
				/*var V = ICchip.getVolt();
				var C = ICchip.getCurr();
				trace(V,C)*/
				//trace(croObj1.visible)
			}
		}

		public function loadTabComponents():TabbedPane{
			
			//tabbedPane=new TabbedPane()
			//tabbedPane.setPos(693.5,160);
			deleteButton1=new Buttons("Delete",640,550)
			deleteButton1.width=50;
			removeFromBoard=new Buttons("Remove From Board",640,525)	
			resistorScroll=new Scroll(690,340,"Resistance Resi:1000 Ohm",1000,10000,1);
			resistorScroll.name="resistorScroll";
			resistorScroll.slider.enabled=false;
			batteryScroll=new Scroll(690,378,"Battery Volt:10 V ",10,20,1);
			batteryScroll.name="batteryScroll";
			batteryScroll.slider.enabled=false;
			capasitorScroll=new Scroll(690,420,"Capacitance:0.1 pf",0.1,1,0.1);
			capasitorScroll.name="capasitorScroll";
			capasitorScroll.slider.enabled=false;
			
			inductorScroll=new Scroll(690,455,"Inductance: 1 Micro H",1,1.3,0.1);
			inductorScroll.name="inductorScroll";
			inductorScroll.slider.enabled=false;
			rotationScroll=new Scroll(690,305,"Component Rotation",0,360,1);
			rotationScroll.name="rotationScroll";
			rotationScroll.slider.enabled=false;
			
			//sgFreScroll=new Scroll(690,330,"SG Frequency",100,333,1);
			//sgFreScroll.name="sgFreScroll";
			//sgFreScroll.slider.enabled=false;
			
			
			//sgVoltScroll=new Scroll(690,363,"SG Voltage",1,5,1);
			//sgVoltScroll.name="sgVoltScroll";
			//sgVoltScroll.slider.enabled=false;
			
			/*static var sgFreScroll:Scroll;
		    static var sgVoltScroll:Scroll;`*/
			rb1 = new RadioButton();
			componentBox.addChild(rb1);
			rb1.move(640, 540);
			rb1.label="Bread Board";
			rb1.groupName="rg1";

			rb2= new RadioButton();
			componentBox.addChild(rb2);
			rb2.move(640, 515);
			rb2.label="Diagram";
			rb2.groupName="rg1";
			rb1.visible=false;
			rb2.visible=false;
			rb2.selected=true;
			rb1.addEventListener(MouseEvent.CLICK, showBreadBoardDiagram);
			rb2.addEventListener(MouseEvent.CLICK, showCircuiteDiagram);
			//var tab1:Pane=tabbedPane.addTab("Visual");
			componentBox.addChild(deleteButton1);	
			componentBox.addChild(resistorScroll);
			componentBox.addChild(batteryScroll);
			componentBox.addChild(capasitorScroll);
			componentBox.addChild(removeFromBoard);
			componentBox.addChild(rotationScroll);
			componentBox.addChild(inductorScroll);
			//componentBox.addChild(sgFreScroll);
			//componentBox.addChild(sgVoltScroll);
			/*var tab2:Pane=tabbedPane.addTab("Circuit");
			var tab3:Pane=tabbedPane.addTab("Advanced");
			
			deleteButton1=new Buttons("DELETE",-35,50);
			showValuesButton=new Buttons("Show Values",-35,0);
			showValuesButton.toggle=true;
			var txt:TextField=new TextField();
			var format=new TextFormat();
			format.size=15;
			format.bold=true;
			txt.setTextFormat(format);
			txt.text="SELECT VIEW";
			txt.x=-40;
			txt.y=-50;
			txt.height=25;
			txt.width=100;
			txt.selectable=false;
			
			var sc:Radio=new Radio("Schematic","Schematic",0,-25);
			splitButton=new Buttons("Split Junction",-35,25);
			//splitButton.visible=false;
			
			tab1.addChild(ll);
			tab1.addChild(sc);	
			tab1.addChild(splitButton);	
			tab1.addChild(deleteButton1);	
			tab1.addChild(showValuesButton);	
			tab1.addChild(txt);	
			
			var saveButton:Buttons=new Buttons("SAVE",-40,-40);
			var loadButton:Buttons=new Buttons("LOAD",-40,-10);
			var resetButton:Buttons=new Buttons("RESET",-40,20);
	
			
			tab2.addChild(saveButton);
			tab2.addChild(loadButton);
			tab2.addChild(resetButton);
		
			wireScroll=new Scroll(0,-10,"WIRE RESISTIVITY",0.01,100,0.01);
			resistorScroll=new Scroll(0,-10,"RESISTANCE",0.1,10000,0.01);
			resistorScroll.visible=false;
			batteryScroll=new Scroll(0,-10,"VOLTAGE",0.01,50,.01);
			batteryScroll.visible=false;
			powerRatingScroll=new Scroll(0,-10,"POWER RATING",0.01,220,1);
			voltageRatingScroll=new Scroll(0,-10,"VOLTAGE RATING",0.01,220,0.5);
					
			checkBox=new CheckBox();
			checkBox.x=tab3.x-tab3.width/2+10;
			checkBox.y=tab3.y+tab3.height/2-50;
			checkBox.label="All";
			polarityBox=new CheckBox();
			polarityBox.x=tab3.x+10;
			polarityBox.y=tab3.y-50;
			polarityBox.label="Reverse";
			polarityBox.visible=false;
			deleteButton2=new Buttons("DELETE",-35,50);
			checkBox.addEventListener(MouseEvent.CLICK,setCheckBoxSelected);
			polarityBox.addEventListener(MouseEvent.CLICK,setPolarityBoxSelected);
			
			powerRatingScroll.width=150;
			powerRatingScroll.height=150;
			powerRatingScroll.labelTxt.y=0.1;
			powerRatingScroll.x=10;
			powerRatingScroll.y=-45;
			powerRatingScroll.slider.visible=false;
			voltageRatingScroll.width=150;
			voltageRatingScroll.height=150;
			voltageRatingScroll.labelTxt.y=0.1;
			voltageRatingScroll.x=10;
			voltageRatingScroll.y=0;
			voltageRatingScroll.slider.visible=false;
			
						
			
			bulbScroll=new MovieClip();
			bulbScroll.addChild(powerRatingScroll);
			bulbScroll.addChild(voltageRatingScroll);
			bulbScroll.visible=false;
			tab3.addChild(wireScroll);
			tab3.addChild(resistorScroll);
			tab3.addChild(batteryScroll);
			tab3.addChild(bulbScroll);
			tab3.addChild(checkBox);
			tab3.addChild(polarityBox);
			tab3.addChild(deleteButton2);
			
			tabbedPane.switchToTab("Visual");
			
			componentBox.addChild(tabbedPane);
			*/
			/*deleteIcon = new DeleteIcon();
			splitIcon =  new SplitIcon();
			deleteIcon.scaleX=0.15;
			deleteIcon.scaleY=0.15;
			deleteIcon.x =  230;
			deleteIcon.y =  210;
			deleteIcon.buttonMode=true;
			splitIcon.x =  260;
			splitIcon.y =  210;		
			splitIcon.scaleX=0.15;
			splitIcon.scaleY=0.15;
			splitIcon.buttonMode=true;
			splitIcon.mouseChildren=false;
			splitIcon.whiteBox.alpha=0;
			componentBox.boundArea.addChild(deleteIcon);
			componentBox.boundArea.addChild(splitIcon);
			deleteIcon.addEventListener(MouseEvent.CLICK,deleteSelected);
			splitIcon.addEventListener(MouseEvent.CLICK,splitSelected);
			deleteIcon.addEventListener(MouseEvent.MOUSE_OVER,showLabel);
			deleteIcon.addEventListener(MouseEvent.MOUSE_OUT,removeLabel);
			splitIcon.addEventListener(MouseEvent.MOUSE_OVER,showLabel);
			splitIcon.addEventListener(MouseEvent.MOUSE_OUT,removeLabel);
			*/
			return tabbedPane;
		}
		function showBreadBoardDiagram(e:MouseEvent):void{
			componentBox.setChildIndex(componentBox.circuitMC,componentBox.numChildren-1);
			componentBox.circuitMC.visible=true;
			componentBox.diagramMC.visible=false;
			componentBox.circuitMC.mask=componentBox.digramMask;
		}
		
		function resetFN(e:MouseEvent){
			ExternalInterface.call("reset");
			}
		
		public static function disableComponent(){
					deleteButton1.enabled=false;
					removeFromBoard.enabled=false;
				}
				
		function showCircuiteDiagram(e:MouseEvent):void{
			componentBox.setChildIndex(componentBox.diagramMC,componentBox.numChildren-1);
			componentBox.diagramMC.visible=true;
			componentBox.circuitMC.visible=false;
			componentBox.diagramMC.mask=componentBox.digramMask;
		}
		function addVoltmeterToStage(e:MouseEvent):void {
			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent is Voltmeter){
				if (e.target.insideArea) {
					nextVoltmeterObj=new Voltmeter();
					nextVoltmeterObj.volt.scaleX=0.55;
					nextVoltmeterObj.volt.scaleY=0.55;
					componentBox.addChild(nextVoltmeterObj);
					nextVoltmeterObj.addEventListener(MouseEvent.MOUSE_UP,addVoltmeterToStage);
					nextVoltmeterObj.addEventListener(MouseEvent.CLICK,changeScroll);
					nextVoltmeterObj.setupVoltmeter();
					nextVoltmeterObj.mouseEnabled=false;
					nextVoltmeterObj.mouseChildren=false;
					nextVoltmeterObj.alpha=0.09;
					e.target.parent.removeEventListener(MouseEvent.MOUSE_UP,addVoltmeterToStage);
				}
			}
		}
		
		function addNonContactAmmeterToStage(e:MouseEvent):void {
			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target is NonContactAmmeter){
				if (e.target.insideArea) {
					nextNonContactObj=new NonContactAmmeter();
					nextNonContactObj.scaleX=0.35;
					nextNonContactObj.scaleY=0.35;
					nextNonContactObj.setPos();
					componentBox.addChild(nextNonContactObj);
					nextNonContactObj.addEventListener(MouseEvent.CLICK,changeScroll);
					nextNonContactObj.addEventListener(MouseEvent.MOUSE_UP,addNonContactAmmeterToStage);
					nextNonContactObj.mouseEnabled=false;
					nextNonContactObj.alpha=0.5;
					e.target.removeEventListener(MouseEvent.MOUSE_UP,addNonContactAmmeterToStage);
				}
			}
		}
		
		function addSwitchToStage(e:MouseEvent):void {
            
			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var switchObj:Branch=new Branch("switch");
					switchObj.scaleX=0.60;
					switchObj.scaleY=0.60;
					switchObj.setPrev(628,310);
					switchObj.setPos();
					switchObj.startJunction.visible=false;
					switchObj.endJunction.visible=false;
					componentBox.addChild(switchObj);
					switchObj.addEventListener(MouseEvent.MOUSE_UP,addSwitchToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addSwitchToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.85;
					e.target.parent.parent.scaleY=.85;
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(switchObj);
					Circuit.circuitAlgorithm();
				}
			}
		}
function addResistorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var resistorObj:Branch=new Branch("resistor");
					resistorObj.scaleX=0.55;
					resistorObj.scaleY=0.55;
					resistorObj.setPrev(713,132);
					resistorObj.setPos();
					resistorObj.startJunction.visible=false;
					resistorObj.endJunction.visible=false;
					componentBox.addChild(resistorObj);
					resistorObj.addEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.55;
					e.target.parent.parent.scaleY=.55;
					//resistorObj.rotation=90;
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					resistorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(resistorObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
					Circuit.circuitAlgorithm();
				}
			}
		}
		function addBulbToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var bulbObj:Branch=new Branch("bulb");
					bulbObj.scaleX=0.65;
					bulbObj.scaleY=0.55;
					bulbObj.setPrev(723,140);
					bulbObj.setPos();
					bulbObj.startJunction.visible=false;
					bulbObj.endJunction.visible=false;
					componentBox.addChild(bulbObj);
					bulbObj.addEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
					//e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					//e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.75;
					e.target.parent.parent.scaleY=.75;
					//powerRatingScroll.addObject(e.target.parent);
					//voltageRatingScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(bulbObj);
					/*if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);*/
					Circuit.circuitAlgorithm();
				}
			}

		}
		function addTransistorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					//trace(e.target+","+e.target.parent+","+e.target.parent.parent);
					var tranObj:Branch=new Branch("Transistor");
					//trace("first Ok");
					tranObj.scaleX=0.60;
					tranObj.scaleY=0.60;
					tranObj.setPrev(640,129);
					tranObj.setPos();
					tranObj.startJunction.visible=false;
					tranObj.endJunction.visible=false;
					tranObj.baseJunction.visible=false;
					componentBox.addChild(tranObj);
					tranObj.addEventListener(MouseEvent.MOUSE_UP,addTransistorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addTransistorToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.baseJunction.visible=true;
					e.target.parent.parent.scaleX=.60;
					e.target.parent.parent.scaleY=.60;
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.baseJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					Circuit.addComponent(e.target.parent.parent);	
					Circuit.addBranchToList(tranObj);
					Circuit.circuitAlgorithm();
				}
			}
		}

		
		function addCapacitorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var capacitorObjNew:Branch=new Branch("capacitorNew");
					capacitorObjNew.scaleX=0.60;
					capacitorObjNew.scaleY=0.60;
					capacitorObjNew.setPrev(645,198)
					capacitorObjNew.setPos();
					capacitorObjNew.startJunction.visible=false;
					capacitorObjNew.endJunction.visible=false;
					componentBox.addChild(capacitorObjNew);
					capacitorObjNew.addEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.startJunction.x=e.target.parent.parent.startJunction.x+5;
					e.target.parent.parent.endJunction.x=e.target.parent.parent.endJunction.x-5;
					//var hitJunc:Junction=new Junction();
					//e.target.parent.parent.startJunction.addEventListener(MouseEvent.CLICK,triggerHitComponentOnBreadBoard);
					//e.target.parent.parent.endJunction.addEventListener(MouseEvent.CLICK,triggerHitComponentOnBreadBoard);
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					//hitJunc.hitComponentOnBreadBoard(e.target.parent.parent.startJunction,e.target.parent.parent.endJunction);
					//e.target.parent.parent.endJunction.x=66;
					//e.target.parent.parent.scaleAll(0.4,.4,1.8,1.2);
					//e.target.parent.parent.scaleJunctions(.8,.8,.7,.7);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					//capacitorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(capacitorObjNew);
					/*if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);*/
					Circuit.circuitAlgorithm();
				}
			}
		}
		public function triggerHitComponentOnBreadBoard(e:MouseEvent):void {
		var hitJunc:Junction=new Junction();
		//trace("*******--"+e.target.dropTarget);
		//hitJunc.hitComponentOnBreadBoard(e.target,e.target.dropTarget);
		}
		
		function addInductorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var inductorObjNew:Branch=new Branch("inductor");
					//inductorObj.scaleAll(0.2,.2,0.6,0.7);
					inductorObjNew.scaleX=0.55;
					inductorObjNew.scaleY=0.70;
					inductorObjNew.setPrev(720,229);
					inductorObjNew.setPos();
					inductorObjNew.startJunction.visible=false;
					inductorObjNew.endJunction.visible=false;
					componentBox.addChild(inductorObjNew);
					inductorObjNew.addEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=0.55;
					e.target.parent.parent.scaleY=0.70;
					//e.target.parent.parent.scaleAll(0.25,.25,0.7,1);
					//e.target.parent.parent.scaleJunctions(.8,.8,.7,.7);
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					//inductorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(inductorObjNew);
					Circuit.circuitAlgorithm();
					/*if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);*/
				}
			}	

		}

		function addAmmeterToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var ammeterObj:Branch=new Branch("ammeter");
					ammeterObj.scaleX=0.75;
					ammeterObj.scaleY=0.75;
					ammeterObj.setPrev(707,321);
					ammeterObj.setPos();
					ammeterObj.startJunction.visible=false;
					ammeterObj.endJunction.visible=false;
					componentBox.addChild(ammeterObj);
					ammeterObj.addEventListener(MouseEvent.MOUSE_UP,addAmmeterToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addAmmeterToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.innerComponent.currText.visible=true;
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=1;
					e.target.parent.parent.scaleY=1;
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(ammeterObj);
					Circuit.circuitAlgorithm();
				}
			}
		}
		
		function addICchipToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var ICchipObj:Branch=new Branch("ICchip");
					ICchipObj.scaleX=0.65;
					ICchipObj.scaleY=0.55;
					ICchipObj.setPrev(630,270);
					ICchipObj.setPos();
					ICchipObj.startJunction.visible=false;
					ICchipObj.endJunction.visible=false;
					
					componentBox.addChild(ICchipObj);
					ICchipObj.addEventListener(MouseEvent.MOUSE_UP,addICchipToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addICchipToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=1;
					e.target.parent.parent.scaleY=1;
					
					arr=new Array;
					for(var i=0;i<4;i++){
						lWireObj1=new Branch("longWire");
						var mJun=new midJunction();
						lWireObj1.scaleX=.05;
						//lWireObj.scaleY=.1;
						mJun.scaleX=20;
						lWireObj1.setPrev(e.target.parent.parent.x + 10 + i * 18,e.target.parent.parent.y-25);
						lWireObj1.setPos();
						lWireObj1.startJunction.visible=false;
						lWireObj1.endJunction.visible=false;
						//lWireObj.startJunction.width=1000;
						//lWireObj.startJunction.height=100;
						componentBox.addChild(lWireObj1);
						//lWireObj.width=20;
						lWireObj1.addChild(mJun);
						arr.push(lWireObj1);
					}
					
										
					
					var jn:Junction=new Junction;
					var ic:ICchip=new ICchip;
					//jn.boardHitJunction(ic.icArray[0].startJunction,e.target.parent.parent.startJunction);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(ICchipObj);
					Circuit.circuitAlgorithm();
				}
			}
		}
		
		public static function chipJun(e:Event){
			if(lWireObj1 != null){
				for(i=0;i<arr.length;i++){
					arr[i].setPrev(e.target.x + 10 + i * 18,e.target.y-25);
					arr[i].setPos();
				}
				
			}
		}
		
		function addCroToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var croObj:Branch=new Branch("cro");
					//croObj.scaleX=0.75;
					//croObj.scaleY=0.75;
					croObj.setPrev(707,500);
					croObj.setPos();
					croObj.startJunction.visible=false;
					croObj.endJunction.visible=false;
					componentBox.addChild(croObj);
					croObj.addEventListener(MouseEvent.MOUSE_UP,addCroToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addCroToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.innerComponent.currText.visible=true;
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=3;
					e.target.parent.parent.scaleY=3;
					e.target.parent.parent.startJunction.scaleX=1/3;
					e.target.parent.parent.startJunction.scaleY=1/3;
					e.target.parent.parent.endJunction.scaleX=1/3;
					e.target.parent.parent.endJunction.scaleY=1/3;
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(croObj);
					Circuit.circuitAlgorithm();
				}
			}
		}

		function addWireToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var wireObj:Branch=new Branch("wire");
					wireObj.scaleX=0.6;
					wireObj.scaleY=0.6;
					wireObj.setPrev(715,190);
					wireObj.setPos();
					wireObj.startJunction.visible=false;
					wireObj.endJunction.visible=false;
					//wireObj.startJunction.width=wireObj.startJunction.width-8;
					//wireObj.endJunction.width=wireObj.endJunction.width-8;
					componentBox.addChild(wireObj);
					wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
					
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addWireToStage);
					//e.target.parent.parent.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
					//hitNeed=false;
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
					e.target.parent.parent.setChildIndex(e.target.parent,e.target.parent.parent.numChildren-1);
					//trace("...hitNeed "+hitNeed);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.6;
					e.target.parent.parent.scaleY=.6;
					//e.target.parent.parent.startJunction.width=e.target.parent.parent.startJunction.width-9;
					//e.target.parent.parent.startJunction.height=e.target.parent.parent.startJunction.height-9;
					//e.target.parent.parent.endJunction.width=e.target.parent.parent.endJunction.width-9;
					//e.target.parent.parent.endJunction.height=e.target.parent.parent.endJunction.height-9;
					//e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					//wireScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(wireObj);
					Circuit.circuitAlgorithm();
				}
			}
		}
				
		public function selectedPos1(e:MouseEvent):void {
			e.target.hitNeed=false;
			//trace('selectedPos1')
			//e.target.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
			componentBox.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
			//e.target.removeEventListener(MouseEvent.MOUSE_DOWN,selectedPos1);
			//hitNeed=true;
			//trace("hitNeed "+hitNeed);
		}
		
		public static function selectedPos(e:MouseEvent):void {
			e.target.hitNeed=true;
			//e.target.hit=true;
			//trace("@@hitNeed "+e.target.toString());
			//e.target.startJunction.visible=false;
			//componentBox.removeEventListener(MouseEvent.MOUSE_UP,selectedPos);
			//var jun:Junction=new Junction;
			//jun.addListenerToJunction();
		}

		function addBatteryToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var batteryObj1:Branch=new Branch("BatteryShade");
					batteryObj1.scaleX=0.6;
					batteryObj1.scaleY=0.6;
					batteryObj1.setPrev(629,230);
					batteryObj1.setPos();
					
					//hitNeed=false;
					batteryObj1.startJunction.visible=false;
					batteryObj1.endJunction.visible=false;
					componentBox.addChild(batteryObj1);
					batteryObj1.alpha=0.1;
					//batteryObj1.addEventListener(MouseEvent.MOUSE_UP,addBatteryToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addBatteryToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.8;
					e.target.parent.parent.scaleY=.8;
					//e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					//e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					//batteryScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(batteryObj1);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
					Circuit.circuitAlgorithm();
				}
			}	

		}
		
		
		function addDiodeToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var DiodeObj:Branch=new Branch("diode");
					DiodeObj.scaleX=0.5;
					DiodeObj.scaleY=0.6;
					DiodeObj.setPrev(635,230);
					DiodeObj.setPos();
					DiodeObj.startJunction.visible=false;
					DiodeObj.endJunction.visible=false;
					componentBox.addChild(DiodeObj);
					DiodeObj.addEventListener(MouseEvent.MOUSE_UP,addDiodeToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addDiodeToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.5;
					e.target.parent.parent.scaleY=.6;
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					e.target.parent.parent.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					//batteryScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(DiodeObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
					Circuit.circuitAlgorithm();
				}
			}	

		}
		
		public static function resetCircuit():void{
			if(Circuit!=null){
				for(var i=0;i<Circuit.branches.length;i++){
					componentBox.removeChild(Circuit.branches[i]);  
					delete(Circuit.branches[i]);
				}
				Circuit.reset();
			}
			if(voltmeterObj!=null)
				componentBox.removeChild(voltmeterObj);
			if(nonContactObj!=null)
				componentBox.removeChild(nonContactObj);
			if(tabbedPane!=null)
				componentBox.removeChild(tabbedPane);
			if(selectedObj!=null)
				selectedObj=null;
			if(selectedJn!=null)
				selectedJn=null;
		}
		
		function changeScroll(e:MouseEvent){
			if(!(e.target.parent.parent is Branch)){
		    }else{
				if(e.target.parent.parent.type=="resistor"){
					resistorScroll.slider.enabled=true;
					resistorScroll.objt=e.target.parent;
					resistorScroll.numberStepper.value=e.target.parent.resistance;
					resistorScroll.slider.value=e.target.parent.resistance;
					if(isNaN(e.target.parent.resistance)){
					resistorScroll.labelTxt.text="Resistance Resi:1000 Ohm";
					}else{
						resistorScroll.labelTxt.text="Resistance Resi:"+e.target.parent.resistance+" Ohm";
					}
				}else{
				resistorScroll.slider.enabled=false;
				}
				if(e.target.parent.parent.type=="battery"){
					batteryScroll.slider.enabled=true;
					batteryScroll.objt=e.target.parent;
					batteryScroll.numberStepper.value=e.target.parent.voltage;
					batteryScroll.slider.value=e.target.parent.voltage;
					if(isNaN(e.target.parent.voltage)){
						batteryScroll.labelTxt.text="Battery Volt:12 V";
					}else{
					batteryScroll.labelTxt.text="Battery Volt:"+e.target.parent.voltage+" V";
					}
				}else{
				batteryScroll.slider.enabled=false;
				}
				if(e.target.parent.parent.type=="capacitorNew"){
					capasitorScroll.slider.enabled=true;
					capasitorScroll.objt=e.target.parent;
					capasitorScroll.numberStepper.value=e.target.parent.capValue;
					capasitorScroll.slider.value=e.target.parent.capValue;
					if(isNaN(e.target.parent.capValue)){
						capasitorScroll.labelTxt.text="Cpasitance:0.1 pf";
					}else{
					capasitorScroll.labelTxt.text="Cpacitance:"+e.target.parent.capValue+" pf";
					}
				}else{
				capasitorScroll.slider.enabled=false;
				}
				if(e.target.parent.parent.type=="inductor"){
					inductorScroll.slider.enabled=true;
					inductorScroll.objt=e.target.parent;
					inductorScroll.numberStepper.value=e.target.parent.inductance;
					inductorScroll.slider.value=e.target.parent.inductance;
					if(isNaN(e.target.parent.inductance)){
						inductorScroll.labelTxt.text="Inductance:1 Micro H";
					}else{
					inductorScroll.labelTxt.text="Inductance:"+e.target.parent.inductance+" Micro H";
					}
				}else{
				inductorScroll.slider.enabled=false;
				}
				if(e.target.parent.parent.type=="Transistor" || e.target.parent.parent.type=="capacitorNew" || e.target.parent.parent.type=="resistor" || e.target.parent.parent.type=="diode" ||  e.target.parent.parent.type=="inductor"){
					//trace(e.target.parent.parent.startJunction.juncConnectedBb+"--"+e.target.parent.parent.endJunction.juncConnectedBb);
					if(e.target.parent.parent.startJunction.juncConnectedBb==false && e.target.parent.parent.endJunction.juncConnectedBb==false ){
					rotationScroll.slider.enabled=true;
					rotationScroll.objt=e.target.parent;
					rotationScroll.numberStepper.value=e.target.parent.ObjRotation;
					rotationScroll.slider.value=e.target.parent.ObjRotation;
					rotationScroll.labelTxt.text="Component Rotation: ";
					}else{
						rotationScroll.slider.enabled=false;
					}
				}else{
				rotationScroll.slider.enabled=false;
				}
			}
			
			/*if(!(e.target.parent.parent is Branch)){
				
				tabbedPane.switchToTab("Visual");				
				deleteButton1.visible=false;
				deleteButton2.visible=false;
				deleteIcon.alpha=.5;
				deleteIcon.mouseEnabled=false;
				splitButton.visible=false;
				splitIcon.alpha=.5;
				splitIcon.mouseEnabled=false;
				if(e.target is Junction){
					if(e.target.neighbours.length>0){
						splitButton.objt=e.target;
						splitButton.visible=true;
						splitIcon.alpha=1;
						splitIcon.mouseEnabled=true;
					}
				}	
			}
			else{
				
				deleteButton1.visible=true;
				deleteButton2.visible=true;
				deleteIcon.alpha=1;
				deleteIcon.mouseEnabled=true;
				splitButton.visible=false;
				splitIcon.alpha=.5;
				splitIcon.mouseEnabled=false;
				//tabbedPane.switchToTab("Advanced");
				if(e.target.parent.parent.type=="wire"){
					wireScroll.objt=e.target.parent;
					if(wireScroll.visible==false){
						//wireScroll.visible=true;
						//resistorScroll.visible=false;
						//batteryScroll.visible=false;
						//polarityBox.visible=false;
						//bulbScroll.visible=false;
					}
					wireScroll.slider.value=wireScroll.objt.resistance;
					wireScroll.numberStepper.value=wireScroll.objt.resistance;
				}
				else if(e.target.parent.parent.type=="resistor"){
					resistorScroll.objt=e.target.parent;
					if(resistorScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=true;
						batteryScroll.visible=false;
						polarityBox.visible=false;
						bulbScroll.visible=false;
					}
					resistorScroll.slider.value=resistorScroll.objt.resistance;
					resistorScroll.numberStepper.value=resistorScroll.objt.resistance;
				}
				else if(e.target.parent.parent.type=="battery"){
					if(batteryScroll.objt!=null)
						batteryScroll.objt.lastChanged=false;
					batteryScroll.objt=e.target.parent;
					if(batteryScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						batteryScroll.visible=true;
						polarityBox.visible=true;
						bulbScroll.visible=false;
					}
					polarityBox.selected=e.target.parent.isReverse;
					batteryScroll.slider.value=batteryScroll.objt.voltage;
					batteryScroll.numberStepper.value=batteryScroll.objt.voltage;
				}
				else if(e.target.parent.parent.type=="bulb"){
					powerRatingScroll.objt=e.target.parent;
					voltageRatingScroll.objt=e.target.parent;
					if(bulbScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						batteryScroll.visible=false;
						polarityBox.visible=false;
						bulbScroll.visible=true;
					}
					powerRatingScroll.slider.value=powerRatingScroll.objt.powerRating;
					powerRatingScroll.numberStepper.value=powerRatingScroll.objt.powerRating;
					voltageRatingScroll.slider.value=voltageRatingScroll.objt.voltageRating;
					voltageRatingScroll.numberStepper.value=voltageRatingScroll.objt.voltageRating;
				}
				else{
					tabbedPane.switchToTab("Visual");
					deleteButton1.visible=true;
					deleteButton2.visible=true;
				}
			}*/
		}
		
		function setCheckBoxSelected(e:MouseEvent):void{
			wireScroll.isCheckBoxSelected=e.target.selected;
			resistorScroll.isCheckBoxSelected=e.target.selected;
			batteryScroll.isCheckBoxSelected=e.target.selected;
			powerRatingScroll.isCheckBoxSelected=e.target.selected;
			voltageRatingScroll.isCheckBoxSelected=e.target.selected;
		}
		
		function setPolarityBoxSelected(e:MouseEvent):void{
			if(!checkBox.selected){
				Circuit.reversePolarity(batteryScroll.objt.parent.ids);
				batteryScroll.objt.realComponent.rotation-=180;
				batteryScroll.objt.schematicComponent.rotation-=180;
				if((batteryScroll.objt.parent.rotation2>90 && batteryScroll.objt.parent.rotation2 <180) ||(batteryScroll.objt.parent.rotation2<-90 && batteryScroll.objt.parent.rotation2>=-180)|| batteryScroll.objt.parent.rotation2==180){
					batteryScroll.objt.fire.rotation=180;
					batteryScroll.objt.fire.y=50;
				}
				else{
					batteryScroll.objt.fire.rotation=0;
					batteryScroll.objt.fire.y=-50;
				}
				batteryScroll.objt.isReverse=polarityBox.selected;
			}
			else{
				for(var i=0;i<batteryScroll.objArray.length;i++){
					Circuit.reversePolarity(batteryScroll.objArray[i].parent.ids);
					batteryScroll.objArray[i].realComponent.rotation-=180;
					batteryScroll.objArray[i].schematicComponent.rotation-=180;
					if((batteryScroll.objArray[i].parent.rotation2>90 && batteryScroll.objArray[i].parent.rotation2 <180) ||(batteryScroll.objArray[i].parent.rotation2<-90 && batteryScroll.objArray[i].parent.rotation2>=-180)|| batteryScroll.objArray[i].parent.rotation2==180){
						batteryScroll.objArray[i].fire.rotation=180;
						batteryScroll.objArray[i].fire.y=50;
					}
					else{
						batteryScroll.objArray[i].fire.rotation=0;
						batteryScroll.objArray[i].fire.y=-50;
					}
					batteryScroll.objArray[i].isReverse=polarityBox.selected;
				}
			}
			Circuit.circuitAlgorithm();
		}
		
		function removeSelected(e:MouseEvent):void{
			
			for(branchCount=0;branchCount<Circuit.branches.length;branchCount++)
			{	
				Circuit.branches[branchCount].innerComponent.removeRotationListeners(Circuit.branches[branchCount].innerComponent);
			}
			/*if(!(e.target is DeleteIcon) && !(e.target is SplitIcon)){
				tabbedPane.switchToTab("Visual");
				if(selectedObj!=null){
					selectedObj.filters=null;
					selectedObj=null;
				}
				if(selectedJn!=null){
					selectedJn.filters=null;
					selectedJn=null;
				}
			}*/
		}
		
		public function showDoc():void{
			if(helpDoc.visible)
				helpDoc.visible=false;
			if(doc.visible){
				doc.visible=false;
				componentBox.setChildIndex(componentBox.boundArea,6);
				setEnabled(true);
			}
			else{
				doc.visible=true;
				componentBox.setChildIndex(componentBox.boundArea,componentBox.numChildren-1);
				setEnabled(false);
			}
		}
		
		public function showHelpDoc():void{
			if(doc.visible)
				doc.visible=false;
			if(helpDoc.visible){
				helpDoc.visible=false;
				componentBox.setChildIndex(componentBox.boundArea,6);
				setEnabled(true);
			}
			else{
				helpDoc.visible=true;
				componentBox.setChildIndex(componentBox.boundArea,componentBox.numChildren-1);
				setEnabled(false);
			}
		}
		
		function setEnabled(flag:Boolean){
			var colorStrength:Number;
			var i:int;
			
			tabbedPane.mouseChildren=flag;
			for(i=0;i<Circuit.branches.length;i++){
				Circuit.branches[i].mouseChildren=flag;
			}
			voltmeterObj.mouseEnabled=flag;
			voltmeterObj.mouseChildren=flag;
			nonContactObj.mouseEnabled=flag;
			
			if(flag){
				colorStrength=1;
				voltmeterObj.alpha=1;
			}
			else{
				colorStrength=0.5;
				voltmeterObj.alpha=0.05;
			}
				
			tabbedPane.alpha=colorStrength;
			for(i=0;i<Circuit.branches.length;i++){
				Circuit.branches[i].alpha=colorStrength;
			}
			nonContactObj.alpha=colorStrength;
		}
		
		function deleteSelected(e:MouseEvent){
			deleteComponent();
		}
		function splitSelected(e:MouseEvent){
			splitJunction();
		}
		public static function deleteComponent(){			
			//trace("selectedObj==="+selectedObj.type);
		if(selectedObj.type!= "CROinputTerminal" && selectedObj.type!= "signalGenerator" && selectedObj.type!="battery" ){ 	
			if(selectedObj!=null){
				componentBox.removeChild(StageBuilder.selectedObj);
				if(selectedObj.startJunction.juncConnectedBb==true ){
					selectedObj.startJunction.juncConnectedBb=false;
					selectedObj.startJunction.dropJunc.alpha=0;
					selectedObj.startJunction.hitNeed==false;
				}
			if(selectedObj.endJunction.juncConnectedBb==true){
				selectedObj.endJunction.juncConnectedBb=false;
				selectedObj.endJunction.dropJunc.alpha=0;
				selectedObj.endJunction.hitNeed==false;
					
			}
			if(selectedObj.baseJunction!=null){
			if(selectedObj.baseJunction.juncConnectedBb==true){
			 selectedObj.baseJunction.juncConnectedBb=false;
			selectedObj.baseJunction.dropJunc.alpha=0;
			selectedObj.baseJunction.hitNeed==false;
			}
			}
				if(selectedObj is Branch){
					Circuit.removeComponent(StageBuilder.selectedObj.ids);					
				}
				else{
					if(selectedObj is Voltmeter){
						nextVoltmeterObj.mouseChildren=true;
						nextVoltmeterObj.mouseEnabled=true;
						nextVoltmeterObj.alpha=1;
						voltmeterObj=StageBuilder.nextVoltmeterObj;
					}
					else if(StageBuilder.selectedObj is NonContactAmmeter){
						nextNonContactObj.mouseEnabled=true;
						nextNonContactObj.alpha=1;
						nonContactObj=StageBuilder.nextNonContactObj;
					}
				}
				selectedObj=null;
			}
		}
		}
		public static function removeObjFromBoard(){			
			
		if(selectedObj.type!= "CROinputTerminal" && selectedObj.type!= "signalGenerator"){ 		
			
			if(selectedObj!=null){
				
		   if(selectedObj.startJunction.juncConnectedBb==true ||selectedObj.endJunction.juncConnectedBb==true || (selectedObj.baseJunction!=null && selectedObj.baseJunction.juncConnectedBb==true)){
				componentBox.removeChild(StageBuilder.selectedObj);
				//trace("selectedObj.x--"+selectedObj.type);
						var newObj:Branch=new Branch(selectedObj.type);
					newObj.scaleX=selectedObj.scaleX;
					newObj.scaleY=selectedObj.scaleY;
					newObj.startJunction.width=selectedObj.startJunction.width;
					newObj.startJunction.height=selectedObj.startJunction.height;
					newObj.endJunction.width=selectedObj.endJunction.width;
					newObj.endJunction.height=selectedObj.endJunction.height;
					newObj.setPrev(selectedObj.x,selectedObj.y);
					newObj.setPos();
					newObj.startJunction.visible=true;
					newObj.endJunction.visible=true;
					if(selectedObj.type=="Transistor"){
						newObj.baseJunction.width=selectedObj.baseJunction.width;
					newObj.baseJunction.height=selectedObj.baseJunction.height;
					newObj.baseJunction.visible=true;
					newObj.baseJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					newObj.baseJunction.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
					}else
					if(selectedObj.type=="wire"){
						newObj.startJunction.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
						newObj.endJunction.addEventListener(MouseEvent.MOUSE_UP,selectedPos);
					}else{
						newObj.startJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
						newObj.endJunction.addEventListener(MouseEvent.MOUSE_DOWN,selectedPos);
					}
					/*if(selectedObj.type=="resistor"){
						newObj.rotation=90;
					}*/
					componentBox.addChild(newObj);
					Circuit.addComponent(newObj);
					Circuit.addBranchToList(newObj);
						
				if(selectedObj.startJunction.juncConnectedBb==true ){
					selectedObj.startJunction.juncConnectedBb=false;
					selectedObj.startJunction.dropJunc.alpha=.1;
					selectedObj.startJunction.hitNeed==false;
				}
			if(selectedObj.endJunction.juncConnectedBb==true){
				selectedObj.endJunction.juncConnectedBb=false;
				selectedObj.endJunction.dropJunc.alpha=.1;
				selectedObj.endJunction.hitNeed==false;
					
			}
			if(selectedObj.baseJunction!=null){
			if(selectedObj.baseJunction.juncConnectedBb==true){
			 selectedObj.baseJunction.juncConnectedBb=false;
			selectedObj.baseJunction.dropJunc.alpha=.1;
			selectedObj.baseJunction.hitNeed==false;
			}
			}
		 }
				
				if(selectedObj is Branch){
					Circuit.removeComponent(StageBuilder.selectedObj.ids);					
				}
				else{
					if(selectedObj is Voltmeter){
						nextVoltmeterObj.mouseChildren=true;
						nextVoltmeterObj.mouseEnabled=true;
						nextVoltmeterObj.alpha=1;
						voltmeterObj=StageBuilder.nextVoltmeterObj;
					}
					else if(StageBuilder.selectedObj is NonContactAmmeter){
						nextNonContactObj.mouseEnabled=true;
						nextNonContactObj.alpha=1;
						nonContactObj=StageBuilder.nextNonContactObj;
					}
				}
				selectedObj=null;
			}	
		}
		}
		
		public static function splitJunction():void{
			if(selectedJn!=null){
				Circuit.splitJunction(selectedJn);
				selectedJn=null;
			}
		}
		function showLabel(e:MouseEvent):void{
			var format:TextFormat = new TextFormat();
			format.color=0X666666;
			labels.defaultTextFormat=format;
			labels.selectable=false;
			if(e.target is DeleteIcon){
				labels.text="DELETE";
				labels.x = 210;
				labels.y = 227;
			}
			else if(e.target is SplitIcon){
				labels.text="SPLIT";
				labels.x = 250;
				labels.y = 227;
			}
			labels.visible=true;
		}
		function removeLabel(e:MouseEvent):void{
			labels.visible=false;
		}
		
		//////////////////////////
		
		var count=0;
		function volt_right_FN(e:MouseEvent){
			
		  count=componentBox.CRO.knobV_total.turner_volt.currentFrame;
		   if(count>1){
		   componentBox.CRO.knobV_total.turner_volt.gotoAndStop(count-1);
		   }  ghYScale=componentBox.CRO.knobV_total.turner_volt.gScale;
			pointsX.splice(0,pointsX.length);
			pointsY.splice(0,pointsY.length);
			outpt_Wave(ghXScale,ghYScale);
		}
		
		//function for volt/div rightbutton
		function volt_left_FN(e:MouseEvent){
			
		   count=componentBox.CRO.knobV_total.turner_volt.currentFrame;
		  // trace(componentBox.CRO.knobV_total.turner_volt.gScale);
		   if(count<12){
		   componentBox.CRO.knobV_total.turner_volt.gotoAndStop(count+1);
		   }
		   ghYScale=componentBox.CRO.knobV_total.turner_volt.gScale;
		   pointsX.splice(0,pointsX.length);
			pointsY.splice(0,pointsY.length);
			outpt_Wave(ghXScale,ghYScale);
						
		}
		var countT=0
		
		//function for time/div rightbutton
		
		function time_left_FN(e:MouseEvent){
			  count=componentBox.CRO.knobT_total.turner_time.currentFrame;
		   if(count>1){
		   componentBox.CRO.knobT_total.turner_time.gotoAndStop(count-1);
		   }  ghXScale=componentBox.CRO.knobT_total.turner_time.gXScale;
			
			pointsX.splice(0,pointsX.length);
			pointsY.splice(0,pointsY.length);
			outpt_Wave(ghXScale,ghYScale);
		}
		
		var lastCount;
		//function for time/div rightbutton
		function time_right_FN(e:MouseEvent){
			
			  count=componentBox.CRO.knobT_total.turner_time.currentFrame;
		   if(count<19){
		   componentBox.CRO.knobT_total.turner_time.gotoAndStop(count+1);
		   }
			  ghXScale=componentBox.CRO.knobT_total.turner_time.gXScale;
			pointsX.splice(0,pointsX.length);
			pointsY.splice(0,pointsY.length);
			outpt_Wave(ghXScale,ghYScale);
		
		}
		
		function moveGraphUp(e:MouseEvent){
			
			  count=componentBox.CRO.graphVerticalKnob.tuner.currentFrame;
		   if(count<143){
		   componentBox.CRO.graphVerticalKnob.tuner.gotoAndStop(count+1);
		  // componentBox.CRO.graphBaseLines.y=componentBox.CRO.graphBaseLines.y-15;
		   spike.y=spike.y-2;
		    spike1.y=spike1.y-2;
		    //totGraphYPos=spike.y;
		   }
				
		
		}
		function moveGraphDown(e:MouseEvent){
			
			  count=componentBox.CRO.graphVerticalKnob.tuner.currentFrame;
		   if(count>1){
		   componentBox.CRO.graphVerticalKnob.tuner.gotoAndStop(count-1);
		   //componentBox.CRO.graphBaseLines.y=componentBox.CRO.graphBaseLines.y+15;
		     spike.y=spike.y+2;
			  spike1.y=spike1.y+2;
			// totGraphYPos=spike.y;
		   }
		   
				
		}
		
	
	function moveGraphRight(e:MouseEvent){
			
			  count=componentBox.CRO.graphHoriKnob.tuner.currentFrame;
		   if(count<143){
		   componentBox.CRO.graphHoriKnob.tuner.gotoAndStop(count+1);
		  // componentBox.CRO.graphBaseLines.x=componentBox.CRO.graphBaseLines.x+20;
		     spike.x=spike.x+2;
			 spike1.x=spike1.x+2;
			  totGraphXPos=spike.x;
		   }
			
			
		}

function moveGraphLeft(e:MouseEvent){
			
			  count=componentBox.CRO.graphHoriKnob.tuner.currentFrame;
		   if(count>1){
		   componentBox.CRO.graphHoriKnob.tuner.gotoAndStop(count-1);
		   //componentBox.CRO.graphBaseLines.x=componentBox.CRO.graphBaseLines.x-20;
		     spike.x=spike.x-2;
			   spike1.x=spike1.x-2;
			    totGraphXPos=spike.x;
		   }
			
			
		}
}
}