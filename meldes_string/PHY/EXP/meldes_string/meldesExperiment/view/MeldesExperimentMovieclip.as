/*
Developed under a Research grant from NMEICT, MHRD 
by 
Amrita CREATE (Center for Research in Advanced Technologies for Education), 
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
package meldesExperiment.view{	
		
		import meldesExperiment.view.*;		
		import flash.display.MovieClip;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import fl.controls.ComboBox; 
		import fl.controls.Button;
		import fl.controls.CheckBox;
		import fl.controls.Label;
		
		public class MeldesExperimentMovieclip extends MovieClip{
			
			public function MeldesExperimentMovieclip() {
				
			}		
						
			public function createTextField(obj:Object,txtLabel:String,isSelectable:Boolean,posX:Number,posY:Number,txtWidth:Number,format:TextFormat):TextField{
				var txtField:TextField = new TextField();
				txtField.text = txtLabel;
				txtField.selectable = isSelectable;						
				txtField.x = posX;
				txtField.y = posY;		
				txtField.width= txtWidth;	
				txtField.height= 20;	
				txtField.setTextFormat(format);
				obj.addChild(txtField);
				return txtField;
			}
			public function createButton(btnLabel:String,posX:Number,posY:Number,txtWidth:Number,isVisible:Boolean):Button{
				var btn:Button = new Button();
				btn.label = btnLabel;
				btn.x = posX;
				btn.y = posY;		
				btn.width= txtWidth;	
				btn.visible = isVisible; 
				return btn;
			}
			public function createComboBox(cbLabels:Array,cbName:String,posX:Number,posY:Number,cbWidth:Number):ComboBox{
				var cb:ComboBox = new ComboBox();
				for (var j=0; j<cbLabels.length; j++){
					cb.addItem({label:cbLabels[j]});
				}
				cb.name = cbName;
				cb.x = posX;
				cb.y = posY;
				cb.width = cbWidth;				
				return cb;
			}
			public function createCheckBox(chkLabel:String,posX:Number,posY:Number,chkWidth:Number):CheckBox{
				var chk:CheckBox = new CheckBox();
				chk.label = chkLabel;
				chk.x = posX;
				chk.y = posY;		
				chk.width= chkWidth;	
				return chk;
				
			}
			public function createLabel(obj:Object,lblTxt:String,isSelectable:Boolean,posX:Number,posY:Number,lblWidth:Number,format:TextFormat):void{
				var lbl:Label = new Label();
				lbl.text = lblTxt;
				lbl.selectable = isSelectable;						
				lbl.x = posX;
				lbl.y = posY;		
				lbl.width= lblWidth;	
				lbl.height= 20;	
				lbl.setTextFormat(format);
				obj.addChild(lbl);				
			}
			
			
						
		}
	}