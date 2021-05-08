/*
Developed under a Research grant from NMEICT, MHRD 
by 
Amrita CREATE (Center for Research in Advanced Technologies for Education), 
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
package meldesExperiment.view{
	import meldesExperiment.*;
	import meldesExperiment.Model.*;
	import meldesExperiment.view.*;
	import meldesExperiment.Controller.*;
	import flash.display.MovieClip;
	import fl.lang.Locale;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.controls.ComboBox;
	import flash.events.MouseEvent;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.CheckBox;
	import fl.controls.Label;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.events.SampleDataEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;

	public class MeldesExperimentView {
		var model:MeldesExperimentModel;
		var controller:MeldesExperimentController;
		var objStage:Object;
		var fullmovie:MovieClip;
		var lan:String;
		var positionX;
		var positionY;
		var loadFont;
		var FontName;
		var format:TextFormat=new TextFormat();
		var Embedded_Font_Format:TextFormat=new TextFormat();
		var resultTxt:TextField=new TextField();
		var materialCombobox:ComboBox;
		var environmentCombobox:ComboBox;
		var rbg:RadioButtonGroup=new RadioButtonGroup("rbRvalues");
		var rb:RadioButton;
		var rbArray:Array=new Array();
		var mass_l_slider:Slider;
		var mass_t_slider:Slider;
		var intscale1_X;
		//var scale_slider:Slider;
		var scale_pos_slider:Slider;
		var volt_Slider:Slider;
		var power_on_btn:Button;
		var power_off_btn:Button;
		var reset_btn:Button;
		var showResultChk:CheckBox=new CheckBox();
		var materialComboboxLabels:Array = new Array();
		var environmentComboboxLabels:Array = new Array();

		var htMc_view:MeldesExperimentMovieclip = new MeldesExperimentMovieclip();
		var Longi;
		var Trans;
		var g=9.8;
		var Lengthsqr=9;
		var loopLensqr_T;
		var loopLensqr_L;
		var mpu=.000035;
		var mass_scale=.0005;
		var wL=.005;
		var wT=.01;
		var scale1_X=0;
		var scalevalue:Number;
		var massperunitT:Number;
		var massperunitL:Number;
		var frequency:Number=60;
		var frequencyArray:Array=new Array(60,55,50,45,40)
		var freq:Number=15;

//var pre
		var newSine:MovieClip =new MovieClip();
		var newSine1:MovieClip =new MovieClip();
		var sine:MovieClip =new MovieClip();
		var sine1:MovieClip =new MovieClip();
		var xpos=-1442
		//var xpos:Number=-1090;
		var ypos:Number=60
		var ypos1:Number=60
		var ang:Number;
		var ampli:Number;
		var sample:Number;
		var mass_in_pan;
		var amp=8;
        var amp1=2
        var amp2=2
		var flag=0
		var flag1=0
		///////////////////////
		var amp_val
		var a1,a2,a3,a4,a5;
		var temp_name;
		var rbLabel:String;

		var muteflag:Boolean=false;
		var mySound:Sound = new Sound();
		var someChannel:SoundChannel = new SoundChannel();
		var someTransform:SoundTransform = new SoundTransform();
		var mass;
		var voltCount=0;
		var tmpArray:Array = new Array();
        //added by sreejesh
		var wireLength=3;
		var waveLengthScale=477;
        var waveLength=0;
		var numberOfLoop:Number
		
		/*********************************************************************************************/


		public function MeldesExperimentView(model:MeldesExperimentModel,controller:MeldesExperimentController,holder:Object, positionX:Number, positionY:Number,loadFont:Object,FontName:String,fullmovie:MovieClip,lan:String,Embedded_Font_Format:TextFormat) {
			// setup mvc references
			this.model=model;
			this.controller=controller;
			this.objStage=holder;
			this.loadFont=loadFont;
			this.FontName=FontName;
			this.fullmovie=fullmovie;
			this.lan=lan;
			this.positionX=positionX;
			this.positionY=positionY;
			format=Embedded_Font_Format;
			loopsL=model.loops_FNL(frequency,wL,g);
			numberOfLoop=loopsL;
			//trace("defaultNumberLoop="+this.numberOfLoop);
			this.waveLength=this.numberOfLoop/this.wireLength;
			this.waveLength=this.waveLength*this.waveLengthScale;
			waveLength=waveLength.toFixed(0);
			//trace("waveLength="+this.waveLength);
			Locale.addXMLPath(lan, "MeldesStringExperiment_"+lan+".xml");
			Locale.setLoadCallback(onLoaded);
			Locale.loadLanguageXML(lan);
			
			
		}

		function power_on_FN(e:MouseEvent) {

			power_off_btn.visible=true;
			power_on_btn.visible=false;
			if (power_on_btn.enabled==true) {
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOnL.visible=true
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOffL.visible=false
				objStage.Exp_Content.transverse_mc.transformer_mc.lightOnT.visible=true
			    objStage.Exp_Content.transverse_mc.transformer_mc.lightOffT.visible=false
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_off.visible=false;
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_on.visible=true;
				objStage.Exp_Content.transverse_mc.transformer_mc.switch_off.visible=false;
				objStage.Exp_Content.transverse_mc.transformer_mc.switch_on.visible=true;
				objStage.Exp_Content.mutesymbol.visible=true;
				objStage.Exp_Content.unmute.visible=false;
				for (i=0; i<tmpArray.length; i++) {
					tmpArray[i].enabled=false;
				}
				objStage.Exp_Content.Longitudinal_mc.spark_mc.visible=true;
				objStage.Exp_Content.Longitudinal_mc.spark_mc.play();
				objStage.Exp_Content.transverse_mc.spark_mc.visible=true;
				objStage.Exp_Content.transverse_mc.spark_mc.play();
				objStage.Exp_Content.Longitudinal_mc.apparatus_mc.string_mc.string_vibration.play();
				objStage.Exp_Content.transverse_mc.string_mc.string_vibration.play();
				objStage.addEventListener(Event.ENTER_FRAME,vibration_FN);
				volt_Slider.addEventListener(SliderEvent.CHANGE, volt_Slider_FN);
				mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel=mySound.play();
				someChannel.addEventListener(Event.SOUND_COMPLETE, doSoundComplete);
				objStage.Exp_Content.mutesymbol.addEventListener(MouseEvent.CLICK,mute_FN);
				objStage.Exp_Content.unmute.addEventListener(MouseEvent.CLICK,unmute_FN);
				
				ampli=volt_Slider.value/50;
				resultTxt.visible=true;
				showResultChk.selected=true;
				//loopsL=model.loops_FNL(frequency,wL,g);
				resultTxt.text=model.frequency_FNL(frequency,mpu,g)+" Hz";
				
				update();
			}
		}
		

		function power_off_FN(e:MouseEvent) {

			power_off_btn.visible=false;
			power_on_btn.visible=true;
			if (power_off_btn.enabled==true) {
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOnL.visible=false
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOffL.visible=true
				objStage.Exp_Content.transverse_mc.transformer_mc.lightOnT.visible=false
			    objStage.Exp_Content.transverse_mc.transformer_mc.lightOffT.visible=true
				resultTxt.visible=false;
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_off.visible=true;
				objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_on.visible=false;
				objStage.Exp_Content.transverse_mc.transformer_mc.switch_off.visible=true;
				objStage.Exp_Content.transverse_mc.transformer_mc.switch_on.visible=false;
				mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
				objStage.Exp_Content.Longitudinal_mc.spark_mc.visible=false;
				objStage.Exp_Content.Longitudinal_mc.spark_mc.stop();
				objStage.Exp_Content.transverse_mc.spark_mc.visible=false;
				objStage.Exp_Content.transverse_mc.spark_mc.stop();
				objStage.Exp_Content.Longitudinal_mc.apparatus_mc.string_mc.string_vibration.stop();
				objStage.Exp_Content.transverse_mc.string_mc.string_vibration.stop();
				objStage.removeEventListener(Event.ENTER_FRAME,vibration_FN);
				objStage.Exp_Content.mutesymbol.removeEventListener(MouseEvent.CLICK,mute_FN);
				objStage.Exp_Content.unmute.removeEventListener(MouseEvent.CLICK,unmute_FN);
				amp=0;
				volt_Slider.enabled=true
				showResultChk.selected=false
				for (i=0; i<tmpArray.length; i++) {
					tmpArray[i].enabled=true;
				}
			}
		}

		function vibration_FN(e:Event) {
			objStage.Exp_Content.Longitudinal_mc.apparatus_mc.string_mc.string_vibration.visible=true;
			objStage.Exp_Content.Longitudinal_mc.apparatus_mc.string_mc.string_vibration.play();
			objStage.Exp_Content.transverse_mc.string_mc.string_vibration.visible=true;
			objStage.Exp_Content.transverse_mc.string_mc.string_vibration.play();
			objStage.Exp_Content.transverse_mc.spark_mc.visible=true;
			objStage.Exp_Content.transverse_mc.spark_mc.play();
			objStage.Exp_Content.Longitudinal_mc.spark_mc.visible=true;
			objStage.Exp_Content.Longitudinal_mc.spark_mc.play();
		}

		function mute_FN(e:MouseEvent) {
			objStage.Exp_Content.mutesymbol.visible=false;
			objStage.Exp_Content.unmute.visible=true;
			mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
			someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
		}
		function unmute_FN(e:MouseEvent) {
			if (muteflag==true) {
				muteflag=false;
			}
			objStage.Exp_Content.mutesymbol.visible=true;
			objStage.Exp_Content.unmute.visible=false;

			if (volt_Slider.value==2) {
				mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
			}
			if (volt_Slider.value==4) {
				mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
			}
			if (volt_Slider.value==6) {
				mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel=mySound.play();
			}
			if (volt_Slider.value==8) {

				mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel=mySound.play();
			}
			if (volt_Slider.value==10) {
				mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
				someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
			}
		}

		function createRadioButton(rbLabel:String,rbg:RadioButtonGroup,i:Number):void {
			
			rb=new RadioButton();
			rb.group=rbg;
			rb.value=i;
			rb.label=rbLabel;
			rb.name=rbLabel;
			objStage.Menu_Content1.addChild(rb);
			rb.x=rb.x+positionX;
			rb.y=rb.y+positionY-50;
			positionY=positionY;
			tmpArray.push(rb);
			if (i+1%2==0) {
				positionY=positionY+rb.height+10;
			}

			if (rbLabel==Trans) {
				rb.y=rb.y+positionY-30;
			}
			if (rbLabel==Longi) {

				rb.selected=true;
				mass_l_slider.visible=true;
				mass_t_slider.visible=false;
				objStage.Exp_Content.massL_in_pan.visible=true;
				objStage.Exp_Content.transverse_mc.visible=false;
				objStage.Exp_Content.Longitudinal_mc.visible=true;
				objStage.Exp_Content.massT_in_pan.visible=false;
				if (power_on_btn.enabled==true) {

					if (mass_l_slider.value==5) {
						loopsL=model.loops_FNL(60,0.005,9.8);
						loopsL=model.loops_FNL(frequency,wL,g);
						objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_T);
						objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_L);
					}
				}

			}
			rb.addEventListener(MouseEvent.CLICK,rbSelected);
		}

		function rbSelected(e:Event):void {
			temp_name=e.target.name
			//trace(temp_name+":::::::::::::::::")
			if (e.target.name==Longi) {
				flag=1
                mass_l_slider.visible=true;
				mass_t_slider.visible=false;
				objStage.Exp_Content.massL_in_pan.visible=true;
				objStage.Exp_Content.transverse_mc.visible=false;
				objStage.Exp_Content.Longitudinal_mc.visible=true;
				objStage.Exp_Content.massT_in_pan.visible=false;
				objStage.Exp_Content.view_txt.text="Top View"
				
				objStage.Exp_Content.zoom_LineL.visible=true
				objStage.Exp_Content.zoom_LineT.visible=false
				
				newSine.visible=true;
				newSine1.visible=true;
				
				if (power_on_btn.enabled==true) {
                 objStage.Exp_Content.massT_in_pan.visible=false;
					if (mass_l_slider.value==5) {
						loopsL=model.loops_FNL(60,0.005,9.8);
						loopsL=model.loops_FNL(frequency,wL,g);
                        objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_T);
						objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_L);
					}
				}


			}
			if (e.target.name==Trans) {
				mass_t_slider.visible=true;
				mass_l_slider.visible=false;
				objStage.Exp_Content.massT_in_pan.visible=true;
				objStage.Exp_Content.Longitudinal_mc.visible=false;
				objStage.Exp_Content.transverse_mc.visible=true;
				objStage.Exp_Content.massL_in_pan.visible=false;
                objStage.Exp_Content.transverse_mc.transformer_mc.lightOnT.visible=false
			    objStage.Exp_Content.transverse_mc.transformer_mc.lightOffT.visible=true
				objStage.Exp_Content.view_txt.text="Front View"
				
				objStage.Exp_Content.zoom_LineL.visible=false
				objStage.Exp_Content.zoom_LineT.visible=true
				
				newSine.visible=true;
				newSine1.visible=true
				
				if (power_on_btn.enabled==true) {
					objStage.Exp_Content.massT_in_pan.visible=true;
                  objStage.Exp_Content.massL_in_pan.visible=false;
					if (mass_t_slider.value==10) {
						loopsT=model.loops_FNT(60,0.01,9.8);
						loopsT=model.loops_FNT(frequency,wT,g);
                        objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_L);
						objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_T);
					}
				}
			} else {
				mass_l_slider.visible=true;
				mass_t_slider.visible=false;
				objStage.Exp_Content.massL_in_pan.visible=true;
				objStage.Exp_Content.transverse_mc.visible=false;
				objStage.Exp_Content.Longitudinal_mc.visible=true;
				objStage.Exp_Content.massT_in_pan.visible=false;

				newSine.visible=true;
				newSine1.visible=true 
				if (power_on_btn.enabled==true) {
                    objStage.Exp_Content.massT_in_pan.visible=false;
					if (mass_l_slider.value==5) {
						loopsL=model.loops_FNL(60,0.005,9.8);
						loopsL=model.loops_FNL(frequency,wL,g);
                        objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_T);
						objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_L);
					}
				}
			}

		}


		function loopsCreation_L(e:Event):void {
			
			newSine.graphics.clear();
			newSine.graphics.lineStyle(1, 0xFFFFFF,.7);
			newSine.graphics.moveTo(xpos, ypos);
			
			newSine1.graphics.clear();
			newSine1.graphics.lineStyle(1, 0xFFFFFF,.7);
			newSine1.graphics.moveTo(xpos, ypos);
			
			
              for (var i:int=xpos; i<=waveLength; i++) {
				ang=Math.PI*loopsL*i/waveLength;
				
				newSine.graphics.lineTo(i, ypos - amp*Math.sin(ang));
				newSine.graphics.lineTo(i, ypos - amp1*Math.sin(ang));
				objStage.Exp_Content.zoom1.scale1.addChild(newSine);
				newSine1.graphics.lineTo(i, ypos1 + amp*Math.sin(ang));
				newSine1.graphics.lineTo(i, ypos1 + amp1*Math.sin(ang));
				objStage.Exp_Content.zoom1.scale1.addChild(newSine1);
			}
			
			if(power_off_btn.visible==true){
				
			if(ypos==60 && ypos1==60){
					 ypos=ypos+.7;
					 ypos1=ypos1+.7
				 }
				else{
					 ypos=ypos-.7;
					 ypos1=ypos1-.7
				 }
			}
			
		}
		function loopsCreation_T(e:Event):void {
			
			newSine.graphics.clear();
			newSine.graphics.lineStyle(1, 0xffffff,.7);
			newSine.graphics.moveTo(xpos, ypos);
			newSine1.graphics.clear();
			newSine1.graphics.lineStyle(1, 0xffffff,.7);
			newSine1.graphics.moveTo(xpos, ypos);
			for (var i:int=xpos; i<=-135; i++) {
				ang=Math.PI*loopsT*i/1250;
				newSine.graphics.lineTo(i, ypos - amp*Math.sin(ang));
				newSine.graphics.lineTo(i, ypos - amp1*Math.sin(ang));
				objStage.Exp_Content.zoom1.scale1.addChild(newSine);
				newSine1.graphics.lineTo(i, ypos1 + amp*Math.sin(ang));
				newSine1.graphics.lineTo(i, ypos1 + amp1*Math.sin(ang));
				objStage.Exp_Content.zoom1.scale1.addChild(newSine1);
			}
			if(power_off_btn.visible==true){
			if(ypos==60 && ypos1==60){
					 ypos=ypos+.7;
					 ypos1=ypos1+.7
				 }
				else{
					 ypos=ypos-.7;
					  ypos1=ypos1-.7
				 }
			}
		}

		public function materialComboboxSelect(e:Event) {
			controller.materialComboboxSelect(e);
			
			//wavelength();
        if (power_off_btn.visible==true) {
			
			if (materialCombobox.selectedIndex==null) {
				frequency=60;
			} else if (materialCombobox.selectedIndex==0) {
				frequency=60;
			} else if (materialCombobox.selectedIndex==1) {
				frequency=55;
			} else if (materialCombobox.selectedIndex==2) {
				frequency=50;
			} else if (materialCombobox.selectedIndex==3) {
				frequency=45;
			} else if (materialCombobox.selectedIndex==4) {
				frequency=40;
			}
			
			
			loopsT=model.loops_FNT(frequency,wT,g);
			loopsL=model.loops_FNL(frequency,wL,g);
			update();
}			
           resultTxt.text=model.frequency_FNL(frequency,mpu,g)+" Hz";
			
		}
		
		public function environmentComboboxSelect(e:Event) {
			controller.environmentComboboxSelect(e);
			//wavelength();
			if (power_off_btn.visible==true) {
			if (environmentCombobox.selectedIndex==null) {
				g=9.8;
			} else if (environmentCombobox.selectedIndex==0) {
				g=9.8;
			} else if (environmentCombobox.selectedIndex==1) {
				g=9.1;
			} else if (environmentCombobox.selectedIndex==2) {
				g=11.28;
			} else if (environmentCombobox.selectedIndex==3) {
				g=25.3;
			}
		update();
		loopsL=model.loops_FNL(frequency,wL,g);
		loopsT=model.loops_FNT(frequency,wT,g);
		}
		}

		function wavelength(){
				loopsL=model.loops_FNL(frequency,wL,g);
			    numberOfLoop=loopsL;
				waveLength=numberOfLoop/wireLength;
			    waveLength=waveLength*waveLengthScale;
			    waveLength=waveLength.toFixed(0);
							
				
	}	

		function mass_l_slider_FN(e:SliderEvent) {
			controller.mass_l_slider_FN(e);
			mass_l_slider.getChildAt(4).text=mass_l_slider.value+" g";
			
			
				wL=mass_l_slider.value/1000;
				objStage.Exp_Content.massL_in_pan.visible=true;
				objStage.Exp_Content.massT_in_pan.visible=false;
				objStage.Exp_Content.massL_in_pan.scaleY=mass_L+(e.target.value-5)/300;
				if (power_off_btn.visible==true) {
				update();
				loopLen_L=model.loops_distFNL(frequency,wL,g);
				loopsL=model.loops_FNL(frequency,wL,g);
				objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_T);
				objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_L);
				
			}
			
		}
		function mass_t_slider_FN(e:SliderEvent) {
			controller.mass_t_slider_FN(e);
			mass_t_slider.getChildAt(4).text=mass_t_slider.value+" g";
			
				wT=mass_t_slider.value/1000;
				objStage.Exp_Content.massT_in_pan.visible=true;
				objStage.Exp_Content.massT_in_pan.scaleY=mass_T+(e.target.value-6)/400;
				loopLen_T=model.loops_distFNT(frequency,wT,g);
				loopsT=model.loops_FNT(frequency,wT,g);
				if (power_off_btn.visible==true) {
					update();
				objStage.Exp_Content.zoom1.scale1.removeEventListener(Event.ENTER_FRAME, loopsCreation_L);
				objStage.Exp_Content.zoom1.scale1.addEventListener(Event.ENTER_FRAME, loopsCreation_T);
			
			}
			
		}
		
		public function forward_FN(e:MouseEvent) {
			
			//if(objStage.Exp_Content.zoom1.ptr.x>=-650.85 && objStage.Exp_Content.zoom1.ptr.x<-590.85){
			if(objStage.Exp_Content.zoom1.ptr.x<-401.5){
			objStage.Exp_Content.zoom1.ptr.x+=5.8
			pre=objStage.Exp_Content.zoom1.ptr.x
			objStage.Exp_Content.zoom1.ptr.x=pre
			//scale_pos_slider.value=scale_pos_slider.value+.01;
			//scale_pos_slider.getChildAt(4).text=scale_pos_slider.value+" m";
			}
			
			trace(objStage.Exp_Content.zoom1.ptr.x+"&&&")
		}
		public function backward_FN(e:MouseEvent) {
			
			if(objStage.Exp_Content.zoom1.ptr.x>-900){
			objStage.Exp_Content.zoom1.ptr.x-=5.8
			pre=objStage.Exp_Content.zoom1.ptr.x; 
			objStage.Exp_Content.zoom1.ptr.x=pre
			//scale_pos_slider.value=scale_pos_slider.value-.01;
			//scale_pos_slider.getChildAt(4).text=scale_pos_slider.value+" m";
				}
			trace(objStage.Exp_Content.zoom1.ptr.x+"&&&");
			
					}
		
		function scale_pos_slider_FN(e:SliderEvent) {//// scale total width---1891.6----*********----// zoom scale width 511.4
			controller.scale_pos_slider_FN(e);
			//scale1_X=1275-(model.getscaleLength()/.01)*5.825;//old
			scale1_X=891-((model.getscaleLength()/.01))*3.28;
			objStage.Exp_Content.zoom1.scale1.x=scale1_X;
			
		}
		function sound() {
			mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, noiseWave);
			someChannel=mySound.play();
			someChannel.addEventListener(Event.SOUND_COMPLETE, doSoundComplete);
		}
		function noiseWave(event:SampleDataEvent):void {
			
			for (var i:int; i<8192; i++) {
				sample=Math.random()-.5
				event.data.writeFloat(sample*ampli);
				event.data.writeFloat(sample*ampli);
			}
		}
		function doSoundComplete(event:Event):void {
			sound();
		}

		function volumeControl(vol:Number) {
			someTransform.volume=vol;
			someChannel.soundTransform=someTransform;
		}

		function volt_Slider_FN(e:SliderEvent) {
			controller.volt_Slider_FN(e);
			volt_Slider.getChildAt(4).text=volt_Slider.value+" v";
			
				if (volt_Slider.value==10) {
					objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*6;
					objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*6;
					if (power_off_btn.visible==true) {
					ampli=.08
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=spark_L-.05
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=spark_L-.05
					objStage.Exp_Content.transverse_mc.spark_mc.scaleX=spark_T-.05
					objStage.Exp_Content.transverse_mc.spark_mc.scaleY=spark_T-.05
					}
				}

				else if (volt_Slider.value==8) {
					objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*2.5;
					objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*2.5;
					if (power_off_btn.visible==true) {
                    ampli=(volt_Slider.value/50)
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=spark_L
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=spark_L
					objStage.Exp_Content.transverse_mc.spark_mc.scaleX=spark_T
					objStage.Exp_Content.transverse_mc.spark_mc.scaleY=spark_T
					}
				}
				else if (volt_Slider.value==6) {
					objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-1.5;
					objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-1.5;
					if (power_off_btn.visible==true) {
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=spark_L-.05
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=spark_L-.05
					objStage.Exp_Content.transverse_mc.spark_mc.scaleX=spark_T-.05
					objStage.Exp_Content.transverse_mc.spark_mc.scaleY=spark_T-.05
					ampli=(volt_Slider.value/75)
					}
					
				}
				else if (volt_Slider.value==4) {
					objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-7;
					objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-7;
					if (power_off_btn.visible==true) {
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=spark_L-.075
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=spark_L-.075
					objStage.Exp_Content.transverse_mc.spark_mc.scaleX=spark_T-.07
					objStage.Exp_Content.transverse_mc.spark_mc.scaleY=spark_T-.07
					ampli=(volt_Slider.value/100)
					}
				}
				else if (volt_Slider.value==2) {
					objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-28;
					objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*-28;
					if (power_off_btn.visible==true) {
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=spark_L-.1
					objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=spark_L-.1
					objStage.Exp_Content.transverse_mc.spark_mc.scaleX=spark_T-.1
					objStage.Exp_Content.transverse_mc.spark_mc.scaleY=spark_T-.1
					ampli=(volt_Slider.value/125)
					}
				} 
				if (power_off_btn.visible==true) {
				 update();
				}
		}
		
		function update(){
			a1=model.getAmp1();
			a2=model.getAmp2();
			a3=model.getAmpL();
			a4=model.getAmpV();
			
			a5=model.getAmpT();
			
			if(isNaN(a1)){
				a1=8; 
			}
			if(isNaN(a2)){
				a2=8;
			}if(isNaN(a3)){
				a3=8;
			}if(isNaN(a4)){
				a4=8;
			}if(isNaN(a5)){
				a5=8;
			}
			
			amp=(a1+a2+a3+a4+a5)/5;
			//trace(amp+"    UPDATE")
			
			
			
		}
		
		function resetBtn_FN(e:MouseEvent) {
			mySound.removeEventListener(SampleDataEvent.SAMPLE_DATA,noiseWave);
			someChannel.removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_on.visible=false;
			objStage.Exp_Content.transverse_mc.transformer_mc.switch_off.visible=true;
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_off.visible=true;
			objStage.Exp_Content.transverse_mc.transformer_mc.switch_on.visible=false;
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOffL.visible=true
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOnL.visible=false
			objStage.Exp_Content.transverse_mc.transformer_mc.lightOnT.visible=false
			objStage.Exp_Content.transverse_mc.transformer_mc.lightOffT.visible=true
			materialCombobox.selectedIndex=0;
			frequency=60
			environmentCombobox.selectedIndex=0;
			g=9.8
			mass_l_slider.value=5;
			mass_l_slider.getChildAt(4).text=mass_l_slider.value+" g";
			mass_t_slider.value=10;
			mass_t_slider.getChildAt(4).text=mass_t_slider.value+" g";
			for (i=0; i<tmpArray.length; i++) {
				tmpArray[i].enabled=true;
			}
			objStage.Exp_Content.unmute.visible=false;
			objStage.Exp_Content.mutesymbol.visible=true;
			showResultChk.selected=false;
			power_on_btn.visible=true;
			power_off_btn.visible=false;
			resultTxt.visible=false;
			volt_Slider.value=8;
			volt_Slider.getChildAt(4).text=volt_Slider.value+" v";
            scale_pos_slider.value=1.5;
			scale_pos_slider.getChildAt(4).text=scale_pos_slider.value+" m";
			objStage.Exp_Content.massL_in_pan.scaleX=0.1356353759765625
			objStage.Exp_Content.massL_in_pan.scaleY=0.1676353759765625
			objStage.Exp_Content.massT_in_pan.scaleX=0.1405181884765625
			objStage.Exp_Content.massT_in_pan.scaleY=0.1505181884765625
			scale1_X=401.75;
			showResultChk.selected==false
			resultTxt.visible=false;
			objStage.Exp_Content.zoom1.scale1.x=scale1_X;
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*2.5;
			voltCount=objStage.Exp_Content.Longitudinal_mc.transformer_mc.knob_mc.rotation;
			objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation=volt_Slider.value*2.5;
			voltCount=objStage.Exp_Content.transverse_mc.transformer_mc.knob_mc.rotation;
			objStage.Exp_Content.Longitudinal_mc.spark_mc.visible=false;
			objStage.Exp_Content.Longitudinal_mc.spark_mc.stop();
			objStage.Exp_Content.transverse_mc.spark_mc.visible=false;
			objStage.Exp_Content.transverse_mc.spark_mc.stop();
			objStage.Exp_Content.Longitudinal_mc.apparatus_mc.string_mc.string_vibration.stop();
			objStage.Exp_Content.transverse_mc.string_mc.string_vibration.stop();
			objStage.removeEventListener(Event.ENTER_FRAME,vibration_FN);
			objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX=0.200775146484375
		    objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleY=0.200775146484375
            objStage.Exp_Content.transverse_mc.spark_mc.scaleX=0.201141357421875
			objStage.Exp_Content.transverse_mc.spark_mc.scaleY=0.201141357421875
			amp=0;
			model.setAmp1(8)
			model.setAmp2(8)
			model.setAmpL(8)
			model.setAmpV(8)
			model.setAmpT(8)
			objStage.Exp_Content.zoom1.ptr.x=-650.85
			loopsL=model.loops_FNL(60,0.005,9.8);
			loopsT=model.loops_FNT(60,0.01,9.8);
			objStage.Exp_Content.mutesymbol.removeEventListener(MouseEvent.CLICK,mute_FN);
			objStage.Exp_Content.unmute.removeEventListener(MouseEvent.CLICK,unmute_FN);
			

		}


		public function showResultFN(e:MouseEvent) {
			if(power_off_btn.visible==true){
			if (showResultChk.selected==true) {
				resultTxt.visible=true;
				resultTxt.text=model.frequency_FNL(frequency,mpu,g)+"   Hz";
				
			} else {
				resultTxt.visible=false;
			}
		}

		}


		function onLoaded(success:Boolean):void {

			rbArray=new Array(Locale.loadString("IDS_LONGI"),Locale.loadString("IDS_TRANS"));
            objStage.Exp_Content.view_txt.text="Top View"
			objStage.Exp_Content.zoom_LineL.visible=true
			objStage.Exp_Content.zoom_LineT.visible=false
			
			
			
			labelMaterial=new TextField();
			labelMaterial=htMc_view.createTextField(objStage.Menu_Content1,Locale.loadString("IDS_TF"),false,positionX,60,165,format);
			materialCombobox = new ComboBox();

			materialComboboxLabels=[Locale.loadString("IDS_T1"),Locale.loadString("IDS_T2"),Locale.loadString("IDS_T3"),Locale.loadString("IDS_T4"),Locale.loadString("IDS_T5")];//making a label array for the choose type
			materialCombobox=htMc_view.createComboBox(materialComboboxLabels,"materialCombobox",positionX,85,155);
			objStage.Menu_Content1.addChild(materialCombobox);
			materialCombobox.addEventListener(Event.CHANGE,materialComboboxSelect);

			labelMaterial=htMc_view.createTextField(objStage.Menu_Content1,Locale.loadString("IDS_ENVIRONMENTS"),false,positionX,110,165,format);
			environmentCombobox = new ComboBox();
			environmentComboboxLabels=[Locale.loadString("IDS_EARTH"),Locale.loadString("IDS_URANUS"),Locale.loadString("IDS_NEPTUNE"),Locale.loadString("IDS_JUPITER")];
			environmentCombobox=htMc_view.createComboBox(environmentComboboxLabels,"environmentCombobox",positionX,135,155);
			objStage.Menu_Content1.addChild(environmentCombobox );
			environmentCombobox.addEventListener(Event.CHANGE,environmentComboboxSelect);

			mass_l_slider = new Slider();
			mass_l_slider=fullmovie.makeSlider(environmentCombobox.x+5,environmentCombobox.y+50,5,25,150,50,Locale.loadString("IDS_MASS_T"),1,0);
			objStage.Menu_Content1.addChild( mass_l_slider);
			mass_l_slider.getChildAt(2).visible=false;
			mass_l_slider.getChildAt(4).text=mass_l_slider.value+" g";
			mass_l_slider.visible=false;
			mass_l_slider.enabled=true;
			mass_l_slider.addEventListener(SliderEvent.CHANGE, mass_l_slider_FN);

			mass_t_slider = new Slider();
			mass_t_slider=fullmovie.makeSlider(environmentCombobox.x+5,environmentCombobox.y+50,10,30,150,50,Locale.loadString("IDS_MASS_L"),1,0);
			objStage.Menu_Content1.addChild( mass_t_slider);
			mass_t_slider.getChildAt(2).visible=false;
			mass_t_slider.getChildAt(4).text=mass_t_slider.value+" g";
			mass_t_slider.visible=false;
			mass_t_slider.enabled=true;
			mass_t_slider.addEventListener(SliderEvent.CHANGE, mass_t_slider_FN);

			scale_pos_slider = new Slider();
			scale_pos_slider=fullmovie.makeSlider(environmentCombobox.x+5,environmentCombobox.y+117,0.5,2.5,150,50,Locale.loadString("IDS_SCALE_POS"),.01,0);
			objStage.Menu_Content1.addChild(scale_pos_slider);
			scale_pos_slider.getChildAt(2).visible=false;
			scale_pos_slider.value=1.5;
			scale1_X=401.75;
			scale_pos_slider.getChildAt(4).visible=false;
			//scale_pos_slider.getChildAt(4).text=scale_pos_slider.value+" m";
			scale_pos_slider.addEventListener(SliderEvent.CHANGE, scale_pos_slider_FN);

			power_on_btn = new Button();
			power_on_btn=htMc_view.createButton(Locale.loadString("IDS_POWERON"),environmentCombobox.x+25,environmentCombobox.y+135,90,true);
			objStage.Menu_Content1.addChild(power_on_btn);
			power_on_btn.enabled=true;
			power_on_btn.addEventListener(MouseEvent.MOUSE_DOWN,power_on_FN);

			power_off_btn = new Button();
			power_off_btn=htMc_view.createButton(Locale.loadString("IDS_POWEROFF"),power_on_btn.x,power_on_btn.y,90,false);
			objStage.Menu_Content1.addChild(power_off_btn);
			power_off_btn.addEventListener(MouseEvent.MOUSE_DOWN,power_off_FN);

			volt_Slider=new Slider();
			volt_Slider=fullmovie.makeSlider(environmentCombobox.x+5,environmentCombobox.y+85,2,10,150,10,Locale.loadString("IDS_VOLT"),2,0);
			objStage.Menu_Content1.addChild(volt_Slider);
			volt_Slider.enabled=true;
			volt_Slider.value=8;
			volt_Slider.getChildAt(2).visible=false;
			volt_Slider.getChildAt(4).text=volt_Slider.value+" v";
			volt_Slider.addEventListener(SliderEvent.CHANGE, volt_Slider_FN);

			reset_btn = new Button();
			reset_btn=htMc_view.createButton(Locale.loadString("IDS_RESET"),environmentCombobox.x+25,environmentCombobox.y+165,90,true);
			objStage.Menu_Content1.addChild(reset_btn);
			reset_btn.addEventListener(MouseEvent.MOUSE_DOWN,resetBtn_FN);

			showResultChk=htMc_view.createCheckBox(Locale.loadString("IDS_SHOWRESULT"),environmentCombobox.x,environmentCombobox.y+200,150);
			objStage.Menu_Content1.addChild(showResultChk);
			showResultChk.addEventListener(MouseEvent.CLICK ,showResultFN);

			result1txt=new TextField();
			result1txt=htMc_view.createTextField(objStage.Menu_Content1,Locale.loadString("IDS_FREQUENCY"),false,0,environmentCombobox.y+260,165,format);
			result1txt.visible=true;

			resultTxt.defaultTextFormat =format
			resultTxt.y=420;
			resultTxt.x=20;
			objStage.Menu_Content1.addChild(resultTxt);
			resultTxt.width=600;
			//format.font = myFont.fontName;
			
			//format.size=24
			//resultTxt.selectable=false;
			resultTxt.visible=false;
			
            
			objStage.Exp_Content.mutesymbol.x=objStage.Exp_Content.unmute.x;
			objStage.Exp_Content.unmute.visible=false;
			objStage.Exp_Content.mutesymbol.buttonMode=true;
			objStage.Exp_Content.unmute.buttonMode=true;

			Longi=rbArray[0];
			Trans=rbArray[1];


			for (var i = 0; i<rbArray.length; i++) {
				createRadioButton(rbArray[i], rbg,i);
				
			}
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOnL.visible=false
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.lightOffL.visible=true
			
			
			objStage.Exp_Content.Longitudinal_mc.transformer_mc.switch_on.visible=false;
			objStage.Exp_Content.transverse_mc.transformer_mc.switch_on.visible=false;
			objStage.Exp_Content.massL_in_pan.visible=true;
			objStage.Exp_Content.massT_in_pan.visible=false;
			
			//mass_L=objStage.Exp_Content.massL_in_pan.scaleX;
			mass_L=objStage.Exp_Content.massL_in_pan.scaleY;
			//trace(mass_L)
			mass_T=objStage.Exp_Content.massT_in_pan.scaleX;
			
			objStage.Exp_Content.Longitudinal_mc.spark_mc.visible=false;
			objStage.Exp_Content.transverse_mc.spark_mc.visible=false;
			spark_L=objStage.Exp_Content.Longitudinal_mc.spark_mc.scaleX
			spark_T=objStage.Exp_Content.transverse_mc.spark_mc.scaleX
			
			amp=0
			amp1=0
			
			
			
			newSine.visible=true;
			newSine1.visible=true;
			
		
			scale1_X=objStage.Exp_Content.zoom1.scale1.x;
            objStage.Exp_Content.forwardArrow.addEventListener(MouseEvent.MOUSE_DOWN,forward_FN);
			objStage.Exp_Content.backwardArrow.addEventListener(MouseEvent.MOUSE_DOWN,backward_FN);
			
			
			
		}
	}
}