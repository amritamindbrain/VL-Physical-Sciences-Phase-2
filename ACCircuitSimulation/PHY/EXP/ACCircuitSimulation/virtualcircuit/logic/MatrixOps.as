/*
Developed under a Research grant from NMEICT, MHRD
by
Amrita CREATE (Center for Research in Advanced Technologies for Education),
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/

package virtualcircuit.logic{
	
	/*
	Standalone class designed to create a matrix and perform different 
	matrix operations. Independant of other classes in the package.
	*/
	public class MatrixOps {

		var nRows:int;	//Stores number of rows
		var nCols:int;	//Stores number of coloumns
		var cell:Array;	//Stores the Matrix as a 2D array
		
		
		public function MatrixOps(nRows:int,nCols:int):void {
			
			this.nRows=nRows;
			this.nCols=nCols;
			this.cell=new Array(nRows);
			for(var i=0;i<nRows;i++){
							cell[i]=new Array(nCols);
			}
		}
		
		public function getRowDimension():int{
			
			return this.nRows;
		}
		
		public function getColumnDimension():int{
			
			return this.nCols;
		}
		
		public function getMatrixCells():Array{
			
			return this.cell;
		}
		
		public function getSubMatrix(i0:int,j0:int, i1:int, j1:int):MatrixOps{
			
			var X:MatrixOps = new MatrixOps(i1-i0+1,j1-j0+1);
      		     		
        	 	for (var i = i0; i <= i1; i++) {
           	 		for (var j = j0; j <= j1; j++) {
               			X.cell[(i-i0)][(j-j0)] = this.cell[i][j];
            		}
         		}

			return X;
		}
		
		public function getSubMatrix2 (r:Array, j0:int,  j1:int):MatrixOps {
		  var X:MatrixOps = new MatrixOps(r.length,j1-j0+1);
			 for (var i = 0; i < r.length; i++) {
				for (var j = j0; j <= j1; j++) {
				    X.cell[i][j-j0] = this.cell[r[i]][j];
				}
			 }
		  return X;
	   }

		/*
		Initialize the Matrix with a test matrix that can give a non-zero determinant.
		Used for generating test cases alone. Experimental function.
		*/
		public function initializeTestMatrix(){	
			
			var cn1:ComplexNumber=new ComplexNumber();
			var cn2:ComplexNumber=new ComplexNumber();
			var cn3:ComplexNumber=new ComplexNumber();
			cn1.rectangularForm(0,0);
			cn2.rectangularForm(2,1);
			cn3.rectangularForm(3,1);
			this.cell[0]=new Array(cn1);//,cn,cn3);
			var cn4:ComplexNumber=new ComplexNumber();
			var cn5:ComplexNumber=new ComplexNumber();
			var cn6:ComplexNumber=new ComplexNumber();
			cn4.rectangularForm(1,3);
			cn5.rectangularForm(3,2);
			cn6.rectangularForm(4,1);
			this.cell[1]=new Array(cn4);//,cn5,cn6);
			
				
		}	

		/*
		Initialize the Matrix with a test matrix that can give a non-zero determinant.
		Used for generating test cases alone. Experimental function.
		*/
		public function initializeTestMatrix2(){	
			
			var cn1:ComplexNumber=new ComplexNumber();
			var cn2:ComplexNumber=new ComplexNumber();
			var cn3:ComplexNumber=new ComplexNumber();
			cn1.rectangularForm(1,2);
			cn2.rectangularForm(2,1);
			cn3.rectangularForm(3,1);
			this.cell[0]=new Array(cn1,cn2);//,cn3);
			var cn4:ComplexNumber=new ComplexNumber();
			var cn5:ComplexNumber=new ComplexNumber();
			var cn6:ComplexNumber=new ComplexNumber();
			cn4.rectangularForm(1,3);
			cn5.rectangularForm(3,2);
			cn6.rectangularForm(4,1);
			this.cell[1]=new Array(cn4,cn5);//,cn6);
			
				
		}	
		
		/*
		--------------------------
		*/
		public function solve(B:MatrixOps):MatrixOps  {
			return ((new LUDecomposition(this)).solve(B));
		}
		
		
		/*
		Returns an identity matrix with the specified dimensions.
		*/
		public function identity(m:int,n:int):MatrixOps {
			
			  var A:MatrixOps = new MatrixOps(m,n);
			  var X:Array = A.getMatrixCells();
			  var one:ComplexNumber=new ComplexNumber();
			  one.rectangularForm(1,0);
			   var zero:ComplexNumber=new ComplexNumber();
			  zero.rectangularForm(0,0);
			  
			  for (var i = 0; i < m; i++) {
				 for (var j = 0; j < n; j++) {
					X[i][j] = (i == j ? one : zero);
				 }
			  }
			  return A;
		}
		
		/*
		Computes the inverse of an invertible matrix using LU Decomposition method
		*/
		public function findInverseMatrixUsingLUD():MatrixOps{
      		return this.solve(identity(this.nRows,this.nRows));
   		}
		
		/*
		Finds the scalar product of two matrices.Second matrix is specified by parameter aMatrix
		*/
		public function matrixMultiplication(aMatrix:MatrixOps):MatrixOps{
			
			if (aMatrix.nRows != this.nCols)
				return null;
			
			var mResult = new MatrixOps(this.nRows, aMatrix.nCols);
			for (var i=0; i<mResult.nRows; i++)
		
			{
				for (var j=0; j<mResult.nCols; j++)
				{
					var cn:ComplexNumber=new ComplexNumber();
					cn.rectangularForm(0,0);
					mResult.cell[i][j]=cn;
					for (var k=0; k<this.nCols; k++)
					{
						mResult.cell[i][j] = ComplexArithmetic.sum(mResult.cell[i][j],ComplexArithmetic.multiply(this.cell[i][k],aMatrix.cell[k][j]));
						
					}
				}
			}
			return mResult;
		}
		
		/*
		Prints the matrix specified by matrix in the parameter list.
		*/
		public function printMatrix(){

			for(var i=0;i<this.nRows;i++){
				for(var j=0;j<this.nCols;j++){
					this.cell[i][j].printNumber();
				}
			}
		}
		
		public function roundMatrixValues(matrix:MatrixOps){

			for(var i=0;i<matrix.nRows;i++){
				for(var j=0;j<matrix.nCols;j++){
					matrix.cell[i][j]=Utilities.roundDecimal(Number(matrix.cell[i][j]),1);
				}
			}
		}
		
		
	}
}