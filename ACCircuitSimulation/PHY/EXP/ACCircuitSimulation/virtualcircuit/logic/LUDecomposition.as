/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic{
	
	public class LUDecomposition {
		
		   var LU:Array;
		   var m:int;
		   var n:int;
		   var pivsign:int; 
 		   var piv:Array;
		
		public function LUDecomposition(A:MatrixOps) {	
         	
			 var i:int;
			 var j:int;
			 var k:int;
		 	 
			
			  this.LU = A.getMatrixCells();
			  this.m = A.getRowDimension();
			  this.n = A.getColumnDimension();
			  this.piv = new Array(m);
			  var cn:ComplexNumber=new ComplexNumber();
			  for (i = 0; i < m; i++) {
					piv[i] = i;
			  }
			  this.pivsign = 1;
			  var LUrowi:Array;//double[]
			  var LUcolj:Array=new Array(m);//double[] LUcolj = new double[m];
		
			  // Outer loop.
		
			  for (j = 0; j < n; j++) {
		
				 // Make a copy of the j-th column to localize references.
		 		 for (i = 0; i < m; i++) {
					LUcolj[i] = LU[i][j];
				 }
				 // Apply previous transformations.
				 for (i = 0; i < m; i++) {
					LUrowi = LU[i];
		
					// Most of the time is spent in the following dot product.
					var kmax:int = Math.min(i,j);
					var s:ComplexNumber = new ComplexNumber();
					s.rectangularForm(0,0);
					for (k = 0; k < kmax; k++) {
					   s = ComplexArithmetic.sum(s,ComplexArithmetic.multiply(LUrowi[k],LUcolj[k]));
					}
					LUcolj[i]= ComplexArithmetic.subract(LUcolj[i],s);
					LUrowi[j] = LUcolj[i];
				 }
		   		 // Find pivot and exchange if necessary.
		
				 var p:int = j;
				 for (i = j+1; i < m; i++) {
					if (LUcolj[i].getMagnitude() > LUcolj[p].getMagnitude()) {
					   p = i;
					}
				 }
				 if (p != j) {
					for (k = 0; k < n; k++) {
					   var t:ComplexNumber = new ComplexNumber();
					   t = LU[p][k]; 
					   LU[p][k] = LU[j][k];
					   LU[j][k] = t;
					}
					k = piv[p]; 
					piv[p] = piv[j]; 
					piv[j] = k;
					pivsign = -pivsign;
				 }
		
				 // Compute multipliers.
				 
				 if (j < m && LU[j][j].getMagnitude() != 0.0) {		//RECONSIDER THE CONDITION
					for (i = j+1; i < m; i++) {
					   LU[i][j]=ComplexArithmetic.divide(LU[i][j],LU[j][j]);
					}
				 }
			  }
			var retMatrix:MatrixOps=new MatrixOps(m,n);
			retMatrix.cell=LU;
			
        }
		
		
		public function isNonsingular():Boolean{
			 for (var j:int = 0; j < n; j++) {
         		if (this.LU[j][j].getMagnitude() == 0)
           			 return false;
      			}
     		 return true;
		}
		
		public function solve(B:MatrixOps):MatrixOps{
			
			  var i:int;
			  var j:int;
			  var k:int;
			 
			  if (B.getRowDimension() != this.m) {
				trace("Matrix row dimensions must agree.");
				return null;
			  }
			  if (!this.isNonsingular()) {
				 return null;
			  }
			  // Copy right hand side with pivoting
			  var nx:int = B.getColumnDimension();
			  var Xmat:MatrixOps = B.getSubMatrix2(piv,0,nx-1);
			
			  var X:Array = Xmat.getMatrixCells();
			
			  // Solve L*Y = B(piv,:)
			  for (k = 0; k < n; k++) {
				 for (i = k+1; i < n; i++) {
					for (j = 0; j < nx; j++) {
					   X[i][j] = ComplexArithmetic.subract(X[i][j],ComplexArithmetic.multiply(X[k][j],LU[i][k]));
					}
				 }
			  }
			  // Solve U*X = Y;
			  for (k = n-1; k >= 0; k--) {
				 for (j = 0; j < nx; j++) {
					X[k][j] = ComplexArithmetic.divide(X[k][j],LU[k][k]);
				 }
				 for (i = 0; i < k; i++) {
					for (j = 0; j < nx; j++) {
					   X[i][j] = ComplexArithmetic..subract(X[i][j],ComplexArithmetic.multiply(X[k][j],LU[i][k]));
					}
				 }
			  }
			  return Xmat;
		}
		
		public function getLU():MatrixOps{
			
			  var retMatrix:MatrixOps=new MatrixOps(this.m,this.n);
			  retMatrix.cell=this.LU;
			  return retMatrix;
		}		
		
	}
	
}