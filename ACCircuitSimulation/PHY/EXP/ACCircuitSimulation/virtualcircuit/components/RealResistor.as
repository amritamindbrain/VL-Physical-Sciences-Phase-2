/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class RealResistor extends MovieClip{
		
		// Constants:
		
		// Public Properties:
		var firstColor:ColorBand; //First Color Band
		var secondColor:ColorBand; // Second Color Band
		var thirdColor:ColorBand;// Third Color Band
		var multiplier:ColorBand;// Fourth Color Band
		var tolerence:ColorBand;// Fifth Color Band
		// Private Properties:
	
		// Initialization:
		//Constructor
		public function RealResistor() { 
				
				//super();
				this.mouseChildren=false;
				this.firstColor=new ColorBand();
				this.firstColor.x=-48;
				this.firstColor.scaleY=1.1;
				this.secondColor=new ColorBand();
				this.secondColor.x=-30;
				this.thirdColor=new ColorBand();
				this.thirdColor.x=-15;
				this.multiplier=new ColorBand();
				this.tolerence=new ColorBand();
				this.tolerence.x=36;
				this.tolerence.transform.colorTransform=new ColorTransform(1,1,1,1,221,141,34,0);
				this.getColorBands(10000);
				this.addChild(firstColor);
				this.addChild(secondColor);
				this.addChild(thirdColor);
				this.addChild(multiplier);
				this.addChild(tolerence);
				this.mouseChildren=false;
			
		}
	
		// Public Methods:
		
		//set the color of the color bands according to the value of the resistance  
		public function getColorBands(resistance:Number):void{
			var n:Number;
			var c:ColorTransform;
			var i:int;
			var temp:String=new String(resistance);
			var index:int=temp.indexOf(".");
			
			if(index!=-1){
				resistance=Number((temp.replace(".","")).substr(0,3));
				temp=temp.substr(index+1);
				this.multiplier.transform.colorTransform=getColor(-temp.length);
			}
			else{
				resistance=Number(temp.substr(0,3));
				temp=temp.substr(3);
				this.multiplier.transform.colorTransform=getColor(temp.length);
			}
			
			for(i=0;i<3;i++){
				n=resistance%10;
				c=getColor(n);
				if(i==0){
					this.thirdColor.transform.colorTransform=c;
				}
				if(i==1){
					this.secondColor.transform.colorTransform=c;
				}
				if(i==2){
					this.firstColor.transform.colorTransform=c;
				}				
				resistance=(Math.floor(resistance/10));
			}
			
			
		}
	
		//Get the color of the color banc according to the color scheme.
		function getColor(i:int):ColorTransform{
			
			switch(i){
				case -1:return new ColorTransform(1,1,1,1,221,141,34,0);
				case -2:return new ColorTransform(1,1,1,1,100,100,100,0);
				case 0:return new ColorTransform(1,1,1,1,0,0,0,0);
				case 1:return new ColorTransform(1,1,1,1,66,33,0,0);
				case 2:return new ColorTransform(1,1,1,1,255,0,0,0);
				case 3:return new ColorTransform(1,1,1,1,255,99,0,0);
				case 4:return new ColorTransform(1,1,1,1,255,255,0,0);
				case 5:return new ColorTransform(1,1,1,1,0,255,0,0);
				case 6:return new ColorTransform(1,1,1,1,0,0,255,0);
				case 7:return new ColorTransform(1,1,1,1,66,0,126,0);
				case 8:return new ColorTransform(1,1,1,1,66,66,66,0);
				case 9:return new ColorTransform(1,1,1,1,255,255,255,0);
			}		
		}
		// Protected Methods:
	}
	
}