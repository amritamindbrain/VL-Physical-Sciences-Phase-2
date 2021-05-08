
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/


package virtualcircuit.logic {
	
	import virtualcircuit.logic.Node;
	
	public class Utilities {
		
		public static function roundDecimal(num:Number, precision:int):Number{
    		var decimalPlaces:Number = Math.pow(10, precision);
    		return Math.round(decimalPlaces * num) / decimalPlaces;
		}
						
	}

}