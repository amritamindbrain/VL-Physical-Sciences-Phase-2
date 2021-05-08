/*
Developed under a Research grant from NMEICT, MHRD 
by 
Amrita CREATE (Center for Research in Advanced Technologies for Education), 
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
package meldesExperiment.Controller{
	import meldesExperiment.Model.*;
	import flash.events.Event;
	import fl.events.SliderEvent;
	import flash.events.MouseEvent;
	
	public class MeldesExperimentController {	
		var model:MeldesExperimentModel;		
		public function MeldesExperimentController(model:MeldesExperimentModel) { 
			// attach model			
			var v;
			this.model = model;			
			
		}
		public function materialComboboxSelect(e:Event):MeldesExperimentModel{
			if(e == null){
				model.setFreq(60);
				model.setAmp1(8);
			}else{
				if(e.target.selectedIndex == 0){
					model.setFreq(60);
					model.setAmp1(8);
				}else if(e.target.selectedIndex == 1){					
					model.setFreq(55);
					model.setAmp1(7);
				}else if(e.target.selectedIndex == 2){
					model.setFreq(50);
					model.setAmp1(6);
				}else if(e.target.selectedIndex == 3){
					model.setFreq(45);
					model.setAmp1(4);
				}else if(e.target.selectedIndex == 4){
					model.setFreq(40);
					model.setAmp1(2);
				}					
			}
			
			return model;			
		}
		public function environmentComboboxSelect(e:Event):MeldesExperimentModel{
			if(e == null){
				model.set_g(9.8);
				model.setAmp2(8);
			}else{
				if(e.target.selectedIndex == 0){
					model.set_g(9.8);
					model.setAmp2(8);
					
				}else if(e.target.selectedIndex == 1){					
					model.set_g(9.01);
					model.setAmp2(6);
					
				}else if(e.target.selectedIndex == 2){
					model.set_g(11.28);
					model.setAmp2(4);
					
				}else if(e.target.selectedIndex == 3){
					model.set_g(25.93);
					model.setAmp2(2);
					
				}
			}
			return model;			
		}
		
		
		public function mass_l_slider_FN(e:SliderEvent):void {
			if (e==null) {
				model.setMassL(5);
				model.setAmpL(8);
			}
			 else {
			model.setMassL(e.target.value/1000);
			model.setAmpL(40/e.target.value);
			
		}
		}
		
		public function mass_t_slider_FN(e:SliderEvent):void {
			if (e==null) {
				model.setMassT(10);
				model.setAmpT(8);
			}
			 else {
			model.setMassT(e.target.value/1000);
			model.setAmpT(80/e.target.value);
			 }
		}
		
		public function scale_pos_slider_FN(e:SliderEvent):void {
			if (e==null) {
				model.setscaleLength(0);
			}
			 else {
				model.setscaleLength(e.target.value);
			}
		
		}
		public function volt_Slider_FN(e:SliderEvent):void {
			if (e==null) {
				model.setAmpV(8);
			}
			 else {
				  v=8-e.target.value
				  if(v<0){
					  v=-1*v;
				  }
				  v=8-v;
				model.setAmpV(v);
			}
		
		}
		
		
	}
}
		
	