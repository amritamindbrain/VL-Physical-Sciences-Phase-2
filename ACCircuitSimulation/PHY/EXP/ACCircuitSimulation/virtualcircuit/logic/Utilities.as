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
		
		//return a decimal after rounding it off to the specified number of decimal places.
		public static function roundDecimal(num:Number, precision:int=2):Number{
    		var decimalPlaces:Number = Math.pow(10, precision);
    		return Math.round(decimalPlaces * num) / decimalPlaces;
		}
		//return a complexNumber after rounding it off to the specified number of decimal places.
		public static function roundComplexNumber(num:ComplexNumber, precision:int=2):ComplexNumber{
			var cn:ComplexNumber=new ComplexNumber();
    		var decimalPlaces:Number = Math.pow(10, precision);
    		var mag:Number=Math.round(decimalPlaces * num.getMagnitude()) / decimalPlaces;
			var angle:Number=Math.round(decimalPlaces * num.getAngle()) / decimalPlaces;
			cn.polarForm(mag,angle);
			return cn;
		}
						
	}

}