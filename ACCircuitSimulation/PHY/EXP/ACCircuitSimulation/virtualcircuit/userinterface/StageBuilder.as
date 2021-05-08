
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.userinterface{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.TextArea;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import virtualcircuit.components.Branch;
	import virtualcircuit.components.Wire;
	import virtualcircuit.components.Resistor;
	import virtualcircuit.components.Bulb;
	import virtualcircuit.components.ACPowerSource;
	import virtualcircuit.components.Capacitor;
	import virtualcircuit.components.Inductor;
	import virtualcircuit.components.Junction;
	import virtualcircuit.components.NonContactAmmeter;
	import virtualcircuit.components.Voltmeter;
	import virtualcircuit.components.VoltPin;
	import virtualcircuit.components.GraphBoard;
	import virtualcircuit.logic.Circuit;
	
	
	
	public class StageBuilder {

		// Constants:
		// Public Properties:

		// Private Properties:
		public static var componentBox:MovieClip;
		public static var nonContactObj:NonContactAmmeter;
		public static var nextNonContactObj:NonContactAmmeter;
		public static var voltmeterObj:Voltmeter;
		public static var nextVoltmeterObj:Voltmeter;
		public static var acObj:Branch=null;
		static var ll:Radio=new Radio("Lifelike","Lifelike",-70,-25);
		static var tabbedPane:TabbedPane;
		static var wireScroll:Scroll;
		static var resistorScroll:Scroll;
		static var bulbScroll:Scroll;
		
		static var capacitorScroll:Scroll;
		static var inductorScroll:Scroll;
		static var frequencyScroll:Scroll;
		static var voltageScroll:Scroll;
		static var checkBox:CheckBox;
		static var frequencyBox:CheckBox;
		public static var selectedObj:Object;
		public static var selectedJn:Junction;
		static var splitButton:Buttons;
		static var deleteButton1:Buttons;
		static var deleteButton2:Buttons;
		static var showValuesButton:Buttons;
		static var graphButton:Buttons;
		static var doc:TextArea;
		static var helpDoc:TextArea;
		static var graphBoard:GraphBoard;
		static var deleteIcon:DeleteIcon;
		static var splitIcon:SplitIcon;
		var labels:TextField = new TextField();
		static var isShowValues:Boolean = false;
		// Initialization:
		
		//Constructor
		public function StageBuilder(rootMovie:MovieClip) {

			branchCount=0;
			junctionCount=0;
			componentBox=rootMovie;
			rootMovie.boundArea.addEventListener(MouseEvent.MOUSE_UP,removeSelected);
			rootMovie.addEventListener(MouseEvent.MOUSE_DOWN,selectedObject);
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
			
			this.loadComponents();
	
		}

		// Public Methods:
		
		// Protected Methods:
		//Loads the Documentation 
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
		
		//Loads the Help Documentation 
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
		
		//Loads All the components onto the Components Tab 
		function loadComponents():void {
			var switchObj:Branch=new Branch("switch");
			switchObj.scaleX=0.60;
			switchObj.scaleY=0.60;
			switchObj.setPrev(628,300);
			switchObj.setPos();
			switchObj.startJunction.visible=false;
			switchObj.endJunction.visible=false;
			componentBox.addChild(switchObj);
			switchObj.addEventListener(MouseEvent.MOUSE_UP,addSwitchToStage);
			Circuit.addBranchToList(switchObj);

			var bulbObj:Branch=new Branch("bulb");
			bulbObj.scaleX=0.65;
			bulbObj.scaleY=0.55;
			bulbObj.setPrev(723,300);
			bulbObj.setPos();
			bulbObj.startJunction.visible=false;
			bulbObj.endJunction.visible=false;
			componentBox.addChild(bulbObj);
			bulbObj.addEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
			Circuit.addBranchToList(bulbObj);
			
			nextNonContactObj=new NonContactAmmeter();
			nonContactObj=nextNonContactObj;
			nextNonContactObj.scaleX=0.35;
			nextNonContactObj.scaleY=0.35;
			nextNonContactObj.setPos();
			componentBox.addChild(nextNonContactObj);
			nextNonContactObj.addEventListener(MouseEvent.CLICK,changeScroll);
			nextNonContactObj.addEventListener(MouseEvent.MOUSE_UP,addNonContactAmmeterToStage);
			
			var resistorObj:Branch=new Branch("resistor");
			resistorObj.scaleX=0.6;
			resistorObj.scaleY=0.6;
			resistorObj.setPrev(715,350);
			resistorObj.setPos();
			resistorObj.startJunction.visible=false;
			resistorObj.endJunction.visible=false;
			componentBox.addChild(resistorObj);
			resistorObj.addEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
			Circuit.addBranchToList(resistorObj);

			var ammeterObj:Branch=new Branch("ammeter");
			ammeterObj.scaleX=0.7;
			ammeterObj.scaleY=0.7;
			ammeterObj.setPrev(708,395);
			ammeterObj.setPos();
			ammeterObj.startJunction.visible=false;
			ammeterObj.endJunction.visible=false;
			componentBox.addChild(ammeterObj);
			ammeterObj.addEventListener(MouseEvent.MOUSE_UP,addAmmeterToStage);
			Circuit.addBranchToList(ammeterObj);
			
			var wireObj:Branch=new Branch("wire");
			wireObj.scaleX=0.7;
			wireObj.scaleY=0.6;
			wireObj.setPrev(710,480);
			wireObj.setPos();
			wireObj.startJunction.visible=false;
			wireObj.endJunction.visible=false;
			componentBox.addChild(wireObj);
			wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
			Circuit.addBranchToList(wireObj);

			nextVoltmeterObj=new Voltmeter();
			voltmeterObj=nextVoltmeterObj;
			nextVoltmeterObj.volt.scaleX=0.55;
			nextVoltmeterObj.volt.scaleY=0.55;
			componentBox.addChild(nextVoltmeterObj);
			nextVoltmeterObj.addEventListener(MouseEvent.MOUSE_UP,addVoltmeterToStage);
			nextVoltmeterObj.addEventListener(MouseEvent.CLICK,changeScroll);
			nextVoltmeterObj.setupVoltmeter();
			
			var capacitorObj:Branch=new Branch("capacitor");
			capacitorObj.scaleAll(0.25,.25,1.8,1.2);
			capacitorObj.setPrev(600,435);
			capacitorObj.setPos();
			capacitorObj.startJunction.visible=false;
			capacitorObj.endJunction.visible=false;
			componentBox.addChild(capacitorObj);
			capacitorObj.addEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
			Circuit.addBranchToList(capacitorObj);			
			
			var inductorObj:Branch=new Branch("inductor");
			inductorObj.scaleAll(0.2,.2,0.6,0.7);
			inductorObj.setPrev(695,440);
			inductorObj.setPos();
			inductorObj.startJunction.visible=false;
			inductorObj.endJunction.visible=false;
			componentBox.addChild(inductorObj);
			inductorObj.addEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
			Circuit.addBranchToList(inductorObj);			
			
			var acPowerObj:Branch=new Branch("ac power");
			acPowerObj.setPrev(695,525);
			acPowerObj.setPos();
			acPowerObj.startJunction.visible=false;
			acPowerObj.endJunction.visible=false;
			acPowerObj.scaleAll(0.23,.23,.6,.6);
			componentBox.addChild(acPowerObj);
			acPowerObj.addEventListener(MouseEvent.MOUSE_UP,addAcPowerToStage);
			Circuit.addBranchToList(acPowerObj);
			
		}
		//Code Added for enabling and disabling delete button and delete Icon
		
		function selectedObject(e:MouseEvent):void {
			if(selectedObj is Branch){
				if(selectedObj.ids!=null){
					deleteButton1.visible=true;
					deleteButton2.visible=true;
					deleteIcon.alpha=1;
					deleteIcon.mouseEnabled=true;
				}else{
					deleteButton1.visible=false;
					deleteButton2.visible=false;
					deleteIcon.alpha=.5;
					deleteIcon.mouseEnabled=false;
				}
			}
		
		}
		//Loads all the required MovieClip and Listners on to the Tab
		public function loadTabComponents():TabbedPane{
			
			tabbedPane=new TabbedPane()
			tabbedPane.setPos(693.5,160);
					
			var tab1:Pane=tabbedPane.addTab("Visual");
			var tab2:Pane=tabbedPane.addTab("Circuit");
			var tab3:Pane=tabbedPane.addTab("Advanced");
			
			deleteButton1=new Buttons("DELETE",-35,50);
			showValuesButton=new Buttons("Show Values",-75,0);
			showValuesButton.toggle=true;
			graphButton=new Buttons("Graph",15,0,60,20);
			graphButton.toggle=true;
						
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
			splitButton.visible=false;
			
			tab1.addChild(ll);
			tab1.addChild(sc);	
			tab1.addChild(splitButton);	
			tab1.addChild(deleteButton1);
			tab1.addChild(showValuesButton);	
			tab1.addChild(graphButton);	
			tab1.addChild(txt);	
			
			var resetButton:Buttons=new Buttons("RESET",-40,-10);
			
			tab2.addChild(resetButton);
		
			wireScroll=new Scroll(0,-10,"WIRE RESISTIVITY",0.01,100,0.01);
			resistorScroll=new Scroll(0,-10,"RESISTANCE",0.1,10000,0.1);
			resistorScroll.visible=false;
			bulbScroll=new Scroll(0,-10,"RESISTANCE",0.1,10000,0.1);
			bulbScroll.visible=false;
			powerRatingScroll=new Scroll(0,-10,"POWER RATING",0.01,220,1);
			voltageRatingScroll=new Scroll(0,-10,"VOLTAGE RATING",0.01,220,0.5);
			capacitorScroll=new Scroll(0,-10,"CAPACITANCE",0.000001,.001,0.000001);
			capacitorScroll.visible=false;
			inductorScroll=new Scroll(0,-10,"INDUCTANCE",0.0001,100,0.0001);
			inductorScroll.visible=false;
			frequencyScroll=new Scroll(0,-10,"FREQUENCY",1,1000,0.01);
			voltageScroll=new Scroll(0,-10,"RMS VOLTAGE",0.01,220,.01);
					
			checkBox=new CheckBox();
			checkBox.x=tab3.x-80;
			checkBox.y=tab3.y+20;
			checkBox.label="All";
			frequencyBox=new CheckBox();
			frequencyBox.x=tab3.x-70;
			frequencyBox.y=tab3.y-33;
			frequencyBox.label="All";
			frequencyBox.selected=true;
			frequencyBox.enabled=false;
			deleteButton2=new Buttons("DELETE",-35,50);
			checkBox.addEventListener(MouseEvent.CLICK,setCheckBoxSelected);
			
			frequencyScroll.width=150;
			frequencyScroll.height=150;
			frequencyScroll.labelTxt.y=0.1;
			frequencyScroll.x=10;
			frequencyScroll.y=-50;
			frequencyScroll.slider.visible=false;
			frequencyScroll.isCheckBoxSelected=true;
			voltageScroll.width=150;
			voltageScroll.height=150;
			voltageScroll.labelTxt.y=0.1;
			voltageScroll.x=10;
			voltageScroll.y=-2;
			voltageScroll.slider.visible=false;
			
			acPowerScroll=new MovieClip();
			acPowerScroll.addChild(frequencyScroll);
			acPowerScroll.addChild(voltageScroll);
			acPowerScroll.visible=false;
			
			tab3.addChild(wireScroll);
			tab3.addChild(resistorScroll);
			tab3.addChild(bulbScroll);
			tab3.addChild(capacitorScroll);
			tab3.addChild(inductorScroll);
			tab3.addChild(acPowerScroll);
			tab3.addChild(checkBox);
			tab3.addChild(frequencyBox);
			tab3.addChild(deleteButton2);
			
			deleteIcon = new DeleteIcon();
			splitIcon =  new SplitIcon();
			deleteIcon.scaleX=0.15;
			deleteIcon.scaleY=0.15;
			deleteIcon.x =  230;
			deleteIcon.y =  210;
			deleteIcon.buttonMode=true;
			splitIcon.x =  270;
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
			
			tabbedPane.switchToTab("Visual");
			componentBox.addChild(tabbedPane);
			
			ll.resetVal(ll);
			return tabbedPane;
		}
		
		//Adds a new Voltmeter to the Components Tab
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
		//Adds a new NonContactAmmeter to the Components Tab
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
		//Adds a new Switch to the Components Tab
		function addSwitchToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var switchObj:Branch=new Branch("switch");
					switchObj.scaleX=0.60;
					switchObj.scaleY=0.60;
					switchObj.setPrev(628,300);
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
					e.target.parent.parent.scaleJunctions(.9,.9);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(switchObj);
					//Circuit.circuitAlgorithm();
				}
			}
		}
		//Adds a new Bulb to the Components Tab
		function addBulbToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var bulbObj:Branch=new Branch("bulb");
					bulbObj.scaleX=0.65;
					bulbObj.scaleY=0.55;
					bulbObj.setPrev(723,300);
					bulbObj.setPos();
					bulbObj.startJunction.visible=false;
					bulbObj.endJunction.visible=false;
					componentBox.addChild(bulbObj);
					bulbObj.addEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addBulbToStage);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.75;
					e.target.parent.parent.scaleY=.75;
					e.target.parent.parent.scaleJunctions(1,1);
					bulbScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(bulbObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
				}
			}

		}
		//Adds a new Resistor to the Components Tab
		function addResistorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var resistorObj:Branch=new Branch("resistor");
					resistorObj.scaleX=0.6;
					resistorObj.scaleY=0.6;
					resistorObj.setPrev(715,350);
					resistorObj.setPos();
					resistorObj.startJunction.visible=false;
					resistorObj.endJunction.visible=false;
					componentBox.addChild(resistorObj);
					resistorObj.addEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addResistorToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.75;
					e.target.parent.parent.scaleY=.75;
					e.target.parent.parent.scaleJunctions(1,1);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					resistorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(resistorObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
				}
			}
		}
		//Adds a new Ammeter to the Components Tab
		function addAmmeterToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var ammeterObj:Branch=new Branch("ammeter");
					ammeterObj.scaleX=0.7;
					ammeterObj.scaleY=0.7;
					ammeterObj.setPrev(708,395);
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
					e.target.parent.parent.scaleJunctions(0.8,0.8);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(ammeterObj);
					//Circuit.circuitAlgorithm();
				}
			}
		}
		//Adds a new Wire to the Components Tab
		function addWireToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var wireObj:Branch=new Branch("wire");
					wireObj.scaleX=0.7;
					wireObj.scaleY=0.6;
					wireObj.setPrev(710,480);
					wireObj.setPos();
					wireObj.startJunction.visible=false;
					wireObj.endJunction.visible=false;
					componentBox.addChild(wireObj);
					wireObj.addEventListener(MouseEvent.MOUSE_UP,addWireToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addWireToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleX=.8;
					e.target.parent.parent.scaleY=.8;
					e.target.parent.parent.scaleJunctions(1,1);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					wireScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(wireObj);
				}
			}
		}
		//Adds a new Capacitor to the Components Tab
		function addCapacitorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var capacitorObj:Branch=new Branch("capacitor");
					capacitorObj.scaleAll(0.25,.25,1.8,1.2);
					capacitorObj.setPrev(600,435);
					capacitorObj.setPos();
					capacitorObj.startJunction.visible=false;
					capacitorObj.endJunction.visible=false;
					componentBox.addChild(capacitorObj);
					capacitorObj.addEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addCapacitorToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleAll(0.4,.4,1.8,1.2);
					e.target.parent.parent.scaleJunctions(.8,.8,.7,.7);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					capacitorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(capacitorObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
				}
			}	

		}
		//Adds a new Inductor to the Components Tab
		function addInductorToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var inductorObj:Branch=new Branch("inductor");
					inductorObj.scaleAll(0.2,.2,0.6,0.7);
					inductorObj.setPrev(695,440);
					inductorObj.setPos();
					inductorObj.startJunction.visible=false;
					inductorObj.endJunction.visible=false;
					componentBox.addChild(inductorObj);
					inductorObj.addEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addInductorToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleAll(0.25,.25,0.7,1);
					e.target.parent.parent.scaleJunctions(.8,.8,.7,.7);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					inductorScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.addBranchToList(inductorObj);
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
				}
			}	

		}
		//Adds a new AcPower to the Components Tab
		function addAcPowerToStage(e:MouseEvent):void {

			//ADD THE COMPONENT TO THE CIRCUIT OBJECT
			if(e.target.parent.parent is Branch){
				if (e.target.parent.parent.insideArea) {
					var acPowerObj:Branch=new Branch("ac power");
					acObj=acPowerObj;
					acPowerObj.setPrev(695,525);
					acPowerObj.setPos();
					acPowerObj.startJunction.visible=false;
					acPowerObj.endJunction.visible=false;
					acPowerObj.scaleAll(0.23,.23,.6,.6);
					componentBox.addChild(acPowerObj);
					acPowerObj.mouseChildren=false;
					acPowerObj.alpha=0.5;
					acPowerObj.addEventListener(MouseEvent.MOUSE_UP,addAcPowerToStage);
					e.target.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,addAcPowerToStage);
					e.target.parent.parent.startJunction.visible=true;
					e.target.parent.parent.endJunction.visible=true;
					e.target.parent.parent.scaleAll(.3,.3,.8,.8);
					e.target.parent.parent.scaleJunctions(.8,.8,.7,.7);
					e.target.parent.parent.addEventListener(MouseEvent.CLICK,changeScroll);
					frequencyScroll.addObject(e.target.parent);
					voltageScroll.addObject(e.target.parent);
					Circuit.addComponent(e.target.parent.parent);			
					Circuit.circuitAlgorithm();
					if(isShowValues)
						e.target.parent.parent.setVal(isShowValues);
				}
			}	

		}
		
		//Resets the whole stage 
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
			if(graphBoard!=null)
				removeGraph();
		}
		
		//changes the contents of the tab according to the MovieClip Selected
		function changeScroll(e:MouseEvent){
			if(!(e.target.parent.parent is Branch)){
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
				tabbedPane.switchToTab("Advanced");
				if(e.target.parent is Wire){
					wireScroll.objt=e.target.parent;
					if(wireScroll.visible==false){
						wireScroll.visible=true;
						resistorScroll.visible=false;
						acPowerScroll.visible=false;
						frequencyBox.visible=false;
						bulbScroll.visible=false;
						capacitorScroll.visible=false;
						inductorScroll.visible=false;
					}
					wireScroll.slider.value=wireScroll.objt.resistance;
					wireScroll.numberStepper.value=wireScroll.objt.resistance;
				}
				else if(e.target.parent is Resistor){
					resistorScroll.objt=e.target.parent;
					if(resistorScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=true;
						acPowerScroll.visible=false;
						frequencyBox.visible=false;
						bulbScroll.visible=false;
						capacitorScroll.visible=false;
						inductorScroll.visible=false;
					}
					resistorScroll.slider.value=resistorScroll.objt.resistance;
					resistorScroll.numberStepper.value=resistorScroll.objt.resistance;
				}
				else if(e.target.parent is ACPowerSource){
					frequencyScroll.objt=e.target.parent;
					voltageScroll.objt=e.target.parent;
					if(acPowerScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						acPowerScroll.visible=true;
						frequencyBox.visible=true;
						bulbScroll.visible=false;
						capacitorScroll.visible=false;
						inductorScroll.visible=false;
					}
					frequencyScroll.slider.value=frequencyScroll.objt.frequency;
					frequencyScroll.numberStepper.value=frequencyScroll.objt.frequency;
					voltageScroll.slider.value=voltageScroll.objt.rmsVoltage;
					voltageScroll.numberStepper.value=voltageScroll.objt.rmsVoltage;
				}
				else if(e.target.parent is Bulb){
					bulbScroll.objt=e.target.parent;
					if(bulbScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						acPowerScroll.visible=false;
						frequencyBox.visible=false;
						bulbScroll.visible=true;
						capacitorScroll.visible=false;
						inductorScroll.visible=false;
					}
					bulbScroll.slider.value=bulbScroll.objt.resistance;
					bulbScroll.numberStepper.value=bulbScroll.objt.resistance;
				}
				else if(e.target.parent is Capacitor){
					capacitorScroll.objt=e.target.parent;
					if(capacitorScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						acPowerScroll.visible=false;
						frequencyBox.visible=false;
						bulbScroll.visible=false;
						capacitorScroll.visible=true;
						inductorScroll.visible=false;
					}
					capacitorScroll.slider.value=capacitorScroll.objt.capacitance;
					capacitorScroll.numberStepper.value=capacitorScroll.objt.capacitance;
				}
				else if(e.target.parent is Inductor){
					inductorScroll.objt=e.target.parent;
					if(inductorScroll.visible==false){
						wireScroll.visible=false;
						resistorScroll.visible=false;
						acPowerScroll.visible=false;
						frequencyBox.visible=false;
						bulbScroll.visible=false;
						capacitorScroll.visible=false;
						inductorScroll.visible=true;
					}
					inductorScroll.slider.value=inductorScroll.objt.inductance;
					inductorScroll.numberStepper.value=inductorScroll.objt.inductance;
				}
				else{
					tabbedPane.switchToTab("Visual");
					deleteButton1.visible=true;
					deleteButton2.visible=true;
				}
			}
		}
		
		//changes setCheckBoxSelected boolean of all Scroll objects to the value of 'ALL' checkBox
		function setCheckBoxSelected(e:MouseEvent):void{
			wireScroll.isCheckBoxSelected=e.target.selected;
			resistorScroll.isCheckBoxSelected=e.target.selected;
			bulbScroll.isCheckBoxSelected=e.target.selected;
			capacitorScroll.isCheckBoxSelected=e.target.selected;
			inductorScroll.isCheckBoxSelected=e.target.selected;
			voltageScroll.isCheckBoxSelected=e.target.selected;
		}

		//Remove the selectedObj and Set the tab to visual when clicked on the stage
		function removeSelected(e:MouseEvent):void{
			trace("devi");
			if(!(e.target is DeleteIcon) && !(e.target is SplitIcon)){
				tabbedPane.switchToTab("Visual");
				if(selectedObj!=null){
					selectedObj.filters=null;
					selectedObj=null;
				}
				if(selectedJn!=null){
					selectedJn.filters=null;
					selectedJn=null;
				}
			}
		}
		
		//Displays the documentation
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
		
		//Displays the help documentation
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
		
		//Sets enabled of all MovieClips on the stage
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
		
		static public function createGraph(){
			graphBoard=new GraphBoard(150,100);
			componentBox.addChild(graphBoard);
			graphBoard.x=componentBox.boundArea.x-componentBox.boundArea.width/2;
			graphBoard.y=componentBox.boundArea.y;
		}
		
		static public function removeGraph(){
			graphBoard.removeAllEnterFrame();
			componentBox.removeChild(graphBoard);
			graphBoard=null;
		}
		
		function deleteSelected(e:MouseEvent){
			deleteComponent();
		}
		function splitSelected(e:MouseEvent){
			splitJunction();
		}
		public static function deleteComponent():void{
			if(selectedObj!=null){
				if(selectedObj is Branch){
					if(selectedObj.ids!=null){
					componentBox.removeChild(selectedObj);
					Circuit.removeComponent(selectedObj.ids);					
					}else{
					selectedObj.filters=null;
					}
					if(selectedObj.type=="ac power"){
						acObj.mouseChildren=true;
						acObj.alpha=1;
						Circuit.addBranchToList(acObj);	
					}
				}
				else{
					if(selectedObj is Voltmeter){
						nextVoltmeterObj.mouseChildren=true;
						nextVoltmeterObj.mouseEnabled=true;
						nextVoltmeterObj.alpha=1;
						voltmeterObj=nextVoltmeterObj;
					}
					else if(selectedObj is NonContactAmmeter){
						nextNonContactObj.mouseEnabled=true;
						nextNonContactObj.alpha=1;
						nonContactObj=nextNonContactObj;
					}
				}
				selectedObj=null;
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
	}

}