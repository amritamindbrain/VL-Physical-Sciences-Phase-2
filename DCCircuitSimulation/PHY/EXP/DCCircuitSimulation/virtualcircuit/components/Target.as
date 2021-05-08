
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
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class Target extends MovieClip{
		
		// Constants:
		// Public Properties:
		// Private Properties:
					
		// Initialization:
		
		public function checkForHit(e:Event){	
			
			
			var obj:Object=null;
			if(HitTest.HitTestObject(DisplayObject(e.target),DisplayObject(this))!=null){
				obj=getComponentUnderTarget(e.target);
				
				
				if((obj!=null )&& (obj.type!="battery")){
					this.parent.currText.text=obj.current+" A";
					trace(obj.type,":",obj.ids)
				}
				else
					this.parent.currText.text="---";					
			}	
		}
		
		function getComponentUnderTarget(obj:Object):Object{
		
			var target:Object=obj;
			try{
				while(!(target is Branch))
				{
					
					if(target is Branch)
						break;
					
						target=target.parent;
					
				}
			}
			catch(ex:Error)
			{
				this.parent.currText.text="---";
				return null;
			}
			
			return target;
		}
	
		// Public Methods:
		
		// Protected Methods:
	}
	
}