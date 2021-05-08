/*
*	RealInductor - Arjun Asok Nair & Sabari S Kumar 
*	
*	This is class represents the RealInductor. 
* 	All properties and functions associated with it is wriiten here. 
*
*
*/
package virtualcircuit.components {
	
	import flash.display.MovieClip;
	
	public class RealInductor extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
	
		// Initialization:
		/*public function RealInductor() {
			this.mouseChildren=false;	
		}*/
	//var gf:GlowFilter;
			 var  realInductorObj:realInductorMc;
			// Initialization:
			 function RealInductor(){
				this.realInductorObj=new realInductorMc();
			this.realInductorObj.x=0;
			this.realInductorObj.y=0;
			this.realInductorObj.width=20;
			this.realInductorObj.height=36;
			this.realInductorObj.mouseEnabled=false;
			addChild(this.realInductorObj);
		// Public Methods:
		// Protected Methods:
	}
	
}
}