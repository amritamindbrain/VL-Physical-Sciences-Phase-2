
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
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