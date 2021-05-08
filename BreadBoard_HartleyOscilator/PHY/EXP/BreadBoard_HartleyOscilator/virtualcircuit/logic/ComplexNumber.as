/*
*	ComplexNumber - Arjun Asok Nair & Sabari S Kumar 
*	
*	This class represents a Complex Number in both the rectangular and polar form of it. 
*	All properties and functions associated with it is wriiten here. 
*
*/
package virtualcircuit.logic{
	
	public class ComplexNumber{
		var real:Number;
		var img:Number;
		var mag:Number;
		var ang:Number;
		var angleRadian:Number;
		
		public function ComplexNumber(){
			real=0;
			img=0;
			mag=0;
			ang=0;
			angleRadian=0;
		} 
		//Creates a Complex number in polar form and finds its rectangular form
		public function polarForm(magnitude:Number,angle:Number){
			this.mag=magnitude;
			this.ang=angle;
			convertPolarToRectangular();			
		}
		//Creates a Complex number in rectangular form and finds its polar form 
		public function rectangularForm(real:Number,imaginery:Number){
			this.real=real;
			this.img=imaginery;
			convertRectangularToPolar();
		}
		//Converts a Complex number in polar form to its rectangular form 
		public function convertPolarToRectangular(){
			this.angleRadian=(this.ang*Math.PI)/180;
			this.real=this.mag*(Math.cos(this.angleRadian));
			this.img=this.mag*(Math.sin(this.angleRadian));
		}
		//Converts a Complex number in rectangular form to its polar form 
		public function convertRectangularToPolar(){
			this.mag=Math.sqrt(Math.pow(this.real,2)+Math.pow(this.img,2));
			this.angleRadian=Math.atan2(this.img,this.real);
			this.ang=(this.angleRadian*180)/Math.PI;
		}
		//returns the magnitude of the complex number
		public function getMagnitude():Number{
			return this.mag;
		} 
		//returns the angle in degrees of the complex number
		public function getAngle():Number{
			return this.ang;
		}
		//returns the angle in radians of the complex number
		public function getAngleInRadian():Number{
			return this.angleRadian;
		}
		//returns the real part of the complex number
		public function getRealPart():Number{
			return this.real;
		}
		//returns the imaginery part of the complex number
		public function getImagineryPart():Number{
			return this.img;
		}
		//print rectangular form
		public function printRect(){
			trace(this.real,this.img+"j");
		}
		//print polar form
		public function printPolar(){
			trace("Polar:",this.mag,this.ang);
		}
		//print the complex number in both rectangular form and polar form
		public function printNumber(){
			trace("Real:",this.real,this.img+"j");
			trace("Polar:",this.mag,"|_"+this.ang);
		}
	}
}