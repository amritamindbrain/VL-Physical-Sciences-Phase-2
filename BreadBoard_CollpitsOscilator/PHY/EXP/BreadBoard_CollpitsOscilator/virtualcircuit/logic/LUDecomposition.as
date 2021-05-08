package virtualcircuit.logic {
	
	import virtualcircuit.logic.Node;
	
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
		 	 //this.LU=tempMatrix.cell;
			 //this.m=tempMatrix.nRows;
			 //this.n=tempMatrix.nCols;
			
			  this.LU = A.getMatrixCells();
			  this.m = A.getRowDimension();
			  this.n = A.getColumnDimension();
			  this.piv = new Array(m);
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
					var s:Number = 0.0;
					for (k = 0; k < kmax; k++) {
					   s += LUrowi[k]*LUcolj[k];
					}
		
					LUrowi[j] = LUcolj[i] -= s;
				 }
		   
				 // Find pivot and exchange if necessary.
		
				 var p:int = j;
				 for (i = j+1; i < m; i++) {
					if (Math.abs(LUcolj[i]) > Math.abs(LUcolj[p])) {
					   p = i;
					}
				 }
				 if (p != j) {
					for (k = 0; k < n; k++) {
					   var t:Number = LU[p][k]; 
					   LU[p][k] = LU[j][k]; LU[j][k] = t;
					}
					k = piv[p]; piv[p] = piv[j]; piv[j] = k;
					pivsign = -pivsign;
				 }
		
				 // Compute multipliers.
				 
				 if (j < m && LU[j][j] != 0.0) {		//RECONSIDER THE CONDITION
					for (i = j+1; i < m; i++) {
					   LU[i][j] /= LU[j][j];
					}
				 }
			  }
			var retMatrix:MatrixOps=new MatrixOps(m,n);
			retMatrix.cell=LU;
			//retMatrix.printMatrix(retMatrix);
			 // return retMatrix;
			
        }
		
		
		public function isNonsingular():Boolean{
			 for (var j:int = 0; j < n; j++) {
         		if (this.LU[j][j] == 0)
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
				return;
			  }
			  if (!this.isNonsingular()) {
				// trace("Matrix is singular.");
				 return;
			  }
				//trace("Matrix is fine.");
			  // Copy right hand side with pivoting
			  var nx:int = B.getColumnDimension();
			  var Xmat:MatrixOps = B.getSubMatrix2(piv,0,nx-1);
			
			  var X:Array = Xmat.getMatrixCells();
			
			  // Solve L*Y = B(piv,:)
			  for (k = 0; k < n; k++) {
				 for (i = k+1; i < n; i++) {
					for (j = 0; j < nx; j++) {
					   X[i][j] -= X[k][j]*LU[i][k];
					}
				 }
			  }
			  // Solve U*X = Y;
			  for (k = n-1; k >= 0; k--) {
				 for (j = 0; j < nx; j++) {
					X[k][j] /= LU[k][k];
				 }
				 for (i = 0; i < k; i++) {
					for (j = 0; j < nx; j++) {
					   X[i][j] -= X[k][j]*LU[i][k];
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
		
		/*public function getLU(A:MatrixOps):MatrixOps{
			
			  LU = A.getMatrixCells();
			  m = A.getRowDimension();
			  n = A.getColumnDimension();
			  piv = new Array(m);
			  for (var i:int = 0; i < m; i++) {
				 piv[i] = i;
			  }
			  pivsign = 1;
			  var LUrowi:Array;//double[]
			  var LUcolj:Array=new Array(m);//double[] LUcolj = new double[m];
		
			  // Outer loop.
		
			  for (var j:int = 0; j < n; j++) {
		
				 // Make a copy of the j-th column to localize references.
		
				 for (var i:int = 0; i < m; i++) {
					LUcolj[i] = LU[i][j];
				 }
		
				 // Apply previous transformations.
		
				 for (var i:int = 0; i < m; i++) {
					LUrowi = LU[i];
		
					// Most of the time is spent in the following dot product.
		
					var kmax:int = Math.min(i,j);
					var s:Number = 0.0;
					for (var k:int = 0; k < kmax; k++) {
					   s += LUrowi[k]*LUcolj[k];
					}
		
					LUrowi[j] = LUcolj[i] -= s;
				 }
		   
				 // Find pivot and exchange if necessary.
		
				 var p:int = j;
				 for (var i:int = j+1; i < m; i++) {
					if (Math.abs(LUcolj[i]) > Math.abs(LUcolj[p])) {
					   p = i;
					}
				 }
				 if (p != j) {
					for (var k:int = 0; k < n; k++) {
					   var t:Number = LU[p][k]; 
					   LU[p][k] = LU[j][k]; LU[j][k] = t;
					}
					var k:int = piv[p]; piv[p] = piv[j]; piv[j] = k;
					pivsign = -pivsign;
				 }
		
				 // Compute multipliers.
				 
				 if (j < m && LU[j][j] != 0.0) {		//RECONSIDER THE CONDITION
					for (var i:int = j+1; i < m; i++) {
					   LU[i][j] /= LU[j][j];
					}
				 }
			  }
			  var retMatrix:MatrixOps=new MatrixOps(m,n);
			  retMatrix.cell=LU;
			  return retMatrix;
			
		}*/
		
		
	}
	
}