package meldesExperiment{
	
	public class MeldesExperiment{
		
		import meldesExperiment.Model.*;
		import meldesExperiment.view.*;
		import meldesExperiment.Controller.*;
		import flash.display.MovieClip;	
		import flash.text.TextFormat;
		
		private var ht_model:MeldesExperimentModel;		
		private var ht_view:MeldesExperimentView;
		private var ht_controller:MeldesExperimentController; 
				
		
		public function MeldesExperiment(holder:Object, positionX:Number, positionY:Number,loadFont:Object,FontName:String,fullmovie:MovieClip,lan:String,Embedded_Font_Format:TextFormat){
				
				// create the data model
				ht_model = new MeldesExperimentModel();
				// create the controller
				ht_controller = new MeldesExperimentController(ht_model);	
				// create the view   
				ht_view=new MeldesExperimentView(ht_model,ht_controller,holder,positionX,positionY,loadFont,FontName,fullmovie,lan,Embedded_Font_Format);
				
				
				// add mb_view as a listener to the mb_model
				//mb_model.addEventListener(MeldesExperimentModel.UPDATE, mb_view.update);
									
		}
		
	}
}