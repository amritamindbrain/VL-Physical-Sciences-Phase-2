
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
	
	public class RedPin extends MovieClip{
	
		var pinTop:RedPinTop;
				
		public function RedPin(){
			
			this.pinTop=new RedPinTop();
			this.pinTop.name="Red Pin Top";
			this.pinTop.x=this.x+2.70;
			this.pinTop.y=this.y-this.height+5;
			
			this.mouseChildren=false;
			
			addChild(this.pinTop);					
		}
		
	}
}