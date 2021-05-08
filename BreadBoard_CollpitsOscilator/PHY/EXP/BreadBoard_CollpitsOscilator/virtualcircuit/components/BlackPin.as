package virtualcircuit.components{
	
	import flash.display.MovieClip;
	
	public class BlackPin extends MovieClip{
	
		var pinTop:BlackPinTop;
				
		public function BlackPin(){
			
			this.pinTop=new BlackPinTop();
			this.pinTop.name="Black Pin Top";
			this.pinTop.x=this.x+3.70;		
			this.pinTop.y=this.y-this.height+5;		
			
			this.mouseChildren=false;
			
			addChild(this.pinTop);			
		}
		
	}
}