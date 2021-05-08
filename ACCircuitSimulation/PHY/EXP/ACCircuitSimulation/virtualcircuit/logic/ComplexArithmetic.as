
/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic{
	
	public class ComplexArithmetic{
		
		//returns the sum of 2 Complex Numbers
		public static function sum(cn1:ComplexNumber,cn2:ComplexNumber):ComplexNumber{
			var ans:ComplexNumber=new ComplexNumber();
			ans.rectangularForm(cn1.getRealPart()+cn2.getRealPart(),cn1.getImagineryPart()+cn2.getImagineryPart());
			return ans;
		}
		//returns the difference of 2 Complex Numbers
		public static function subract(cn1:ComplexNumber,cn2:ComplexNumber):ComplexNumber{
			var ans:ComplexNumber=new ComplexNumber();
			ans.rectangularForm(cn1.getRealPart()-cn2.getRealPart(),cn1.getImagineryPart()-cn2.getImagineryPart());
			return ans;
		}
		//multiplies 2 Complex Numbers and returns the result
		public static function multiply(cn1:ComplexNumber,cn2:ComplexNumber):ComplexNumber{
			var ans:ComplexNumber=new ComplexNumber();
			ans.polarForm(cn1.getMagnitude()*cn2.getMagnitude(),cn1.getAngle()+cn2.getAngle());
			return ans;
		}
		//divides 2 Complex Numbers and returns the result
		public static function divide(cn1:ComplexNumber,cn2:ComplexNumber):ComplexNumber{
			var ans:ComplexNumber=new ComplexNumber();
			ans.polarForm(cn1.getMagnitude()/cn2.getMagnitude(),cn1.getAngle()-cn2.getAngle());
			return ans;
		}
	}

}