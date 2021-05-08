package virtualcircuit.components {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class RealResistor extends MovieClip{
		
		// Constants:
		
		// Public Properties:
		var prevWidth:Number;
		var firstColor:ColorBand;
		var secondColor:ColorBand;
		var thirdColor:ColorBand;
		var multiplier:ColorBand;
		var tolerence:ColorBand;
		// Private Properties:
	
		// Initialization:
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
				//this.scaleX=2;
			
		}
	
		// Public Methods:
		
		public function getPrevWidth():Number{
			return this.prevWidth;
		}
		
		public function setPrevWidth(w:Number){
			this.prevWidth=w;
		}
		
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