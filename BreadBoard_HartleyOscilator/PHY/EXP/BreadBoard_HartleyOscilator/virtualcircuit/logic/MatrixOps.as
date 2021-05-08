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
               			//B[i-i0][j-j0] = A[i][j];
						X.cell[(i-i0)][(j-j0)] = this.cell[i][j];
            			}
         			}

			return X;
		}
		
		public function getSubMatrix2 (r:Array, j0:int,  j1:int):MatrixOps {
		  var X:MatrixOps = new MatrixOps(r.length,j1-j0+1);
		  //var B:Array = X.getMatrixCells();
			 for (var i = 0; i < r.length; i++) {
				for (var j = j0; j <= j1; j++) {
				   //B[i][j-j0] = A[r[i]][j];
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
			var k:int=1;
			for(var i=0;i<this.nRows;i++){
				for(var j=0;j<this.nCols;j++){
					
					this.cell[i][j]=Math.random()%9;//k++;//j-i+k++;//i+j+1;
				}
				//this.cell[5][2]=13;
			}
		}
		
		/*
		Initialize the Matrix with a test matrix that can give a non-zero determinant.
		Used for generating test cases alone. Experimental function.
		*/
		public function initializeTestMatrix2(){	
				
			this.cell[0]=new Array(1,2,1);//
			this.cell[1]=new Array(3,1,4);
			this.cell[2]=new Array(1,4,4);
				
		}
		
				
		/*
		Initialize the Matrix with a test matrix that can give a non-zero determinant.
		Used for generating test cases alone. Experimental function.
		*/
		public function initializeTestMatrix3(){	
				
			this.cell[0]=new Array(1,3,4);//1;
			this.cell[1]=new Array(2,2,1);//2;
			this.cell[2]=new Array(3,1,1);//3;
				
		}

		
		
		/*
		Finds the minor of a matrix. Minor of a matrix is its own submatrix obtained by omitting
		the row and coloumn specified by rowIndex and colIndex. Used in computing determinant and 
		cofactor matrix.
		*/
		public function findMinorMatrix(rowIndex:int,colIndex:int):MatrixOps{
		
			if (this.nRows != this.nCols || this.nCols < 2)
				return null;
				var i,j;
				var mResult = new MatrixOps(this.nRows -1, this.nCols-1);
				for (i=0; i<rowIndex; i++)
				{
					for (j=0; j<colIndex; j++)
					{
						mResult.cell[i][j]= this.cell[i][j];
					}
					for (j=colIndex+1; j<this.nCols; j++)
					{
						mResult.cell[i][j-1]= this.cell[i][j];
					}
				}
				for (i=rowIndex+1; i<this.nRows; i++)
				{
					for (j=0; j<colIndex; j++)
					{
						mResult.cell[i-1][j]= this.cell[i][j];
					}
					for (j=colIndex+1; j<this.nCols; j++)
					{
						mResult.cell[i-1][j-1]= this.cell[i][j];
					}
				}
			return mResult;
		}
		
		
		/*
		Finds the determinant of a matrix.
		*/
		public function findMatrixDeterminant(){
			
			if (this.nRows != this.nCols)
				return null;
			if (this.nRows == 2)
				return this.cell[0][0]*this.cell[1][1]-this.cell[0][1]*this.cell[1][0];
			if (this.nRows == 1)
				return this.cell[0][0];
			var minorIJ;
			var detIJ;
			var determinant = 0;
			var sign=1;
			for (var j=0; j<this.nCols; j++)
			{
				
				minorIJ = this.findMinorMatrix(0,j);
				detIJ = minorIJ.findMatrixDeterminant();
				determinant += sign * detIJ * this.cell[0][j];
				sign = -sign;
			}
			return determinant;
		}
		
		/*
		Finds the transpose of a matrix. Transpose of a matrix is obtained by swapping the element 
		at position (i,j) with element at position (j,i).
		*/
		public function findMatrixTranspose():MatrixOps{
			
			var mResult = new MatrixOps(this.nCols, this.nRows);
			for (var i=0; i<mResult.nRows; i++)
			{
				for (var j=0; j<mResult.nCols; j++)
				{
					mResult.cell[i][j]= this.cell[j][i];
				}
			}
			return mResult;
		}
		
		/*
		Multiplies the matrix with a constant value specified by scalarValue.
		*/
		public function scalarMultiplication(scalarValue:Number):MatrixOps{
			
			var mResult = new MatrixOps(this.nRows, this.nCols);
			for (var i=0; i<mResult.nRows; i++)
			{
				for (var j=0; j<mResult.nCols; j++)
				{
					mResult.cell[i][j]= this.cell[i][j] * scalarValue;
				}
			}
			return mResult;
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
			  for (var i = 0; i < m; i++) {
				 for (var j = 0; j < n; j++) {
					X[i][j] = (i == j ? 1.0 : 0.0);
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
		Computes the inverse of an invertible matrix.
		*/
		public function findInverseMatrix():MatrixOps{
			var determinant = this.findMatrixDeterminant();
			var mResult = this.findCofactorMatrix();
			mResult = mResult.findMatrixTranspose();
			mResult = mResult.scalarMultiplication(1/determinant);
			return mResult;
		}
		
		/*
		Computes the cofactor matrix.
		*/
		public function findCofactorMatrix(){
			
			if (this.nRows != this.nCols)
				return null;
			if (this.nRows == 1)
				return this;
			var minorIJ;
			var detIJ;
			var determinant = 0;
			var sign=1;
			var mResult=new MatrixOps(this.nCols, this.nRows);
			for (var i=0; i<mResult.nRows; i++)
			{
				for (var j=0; j<mResult.nCols; j++)
				{
					minorIJ = this.findMinorMatrix(i,j);
					detIJ = minorIJ.findMatrixDeterminant();
					mResult.cell[i][j]= detIJ * Math.pow(-1,i+j);
				}
			}
			return mResult;		
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
					mResult.cell[i][j]=0;
					for (var k=0; k<this.nCols; k++)
					{
						mResult.cell[i][j] += this.cell[i][k] * aMatrix.cell[k][j];
						
					}
				}
			}
			//mResult.roundMatrixValues(mResult);
			return mResult;
		}
		
		/*
		Prints the matrix specified by matrix in the parameter list.
		*/
		public function printMatrix(matrix:MatrixOps){

			for(var i=0;i<matrix.nRows;i++){
				for(var j=0;j<matrix.nCols;j++){
					trace(matrix.cell[i][j]);
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