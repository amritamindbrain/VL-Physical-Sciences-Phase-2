package virtualcircuit.logic {
	
	import virtualcircuit.logic.Node;
	
	public class Utilities {
		
		public static function roundDecimal(num:Number, precision:int):Number{
    		var decimalPlaces:Number = Math.pow(10, precision);
    		return Math.round(decimalPlaces * num) / decimalPlaces;
		}
						
	}

}