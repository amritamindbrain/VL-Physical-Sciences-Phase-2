/*
Developed under a Research grant from NMEICT, MHRD 
by 
Amrita CREATE (Center for Research in Advanced Technologies for Education), 
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
//newtons forwarded divided difference formula for unequal intervals
function newtonsDividedDiff(arr_x:Array, arr_y:Array, arr_x_values:Array): Array{
		var tempFOfX:Array=new Array();
		tempFOfX=arr_y;
		var fOfX:Array=new Array();
		var slnY:Array=new Array();
		var i=0;
		//
		var xInterval=1;
		//building the table 
		//and iterating the f(x) values in differnt digrees
		do
		{
			fOfX[i]=tempFOfX[0];
			i++;
			var xIndex=0;
			for(var j=1;j<tempFOfX.length;j++)
			{
				var sln:int = (tempFOfX[j]-tempFOfX[j-1])/(arr_x[xIndex+xInterval]-arr_x[xIndex]);
				tempFOfX[xIndex]=sln;
				xIndex++;
			}
			var spliced:Array = tempFOfX.splice(xIndex,1);
			xInterval++;
		}while(tempFOfX.length>1);
		if(tempFOfX[0]!="")
		{
			fOfX[i]=tempFOfX[0];
		}
		//
		//******************************************************/
		//applying the iteratd values to the taylors series
		for(var l=0;l<arr_x_values.length;l++)
		{
			var sumSln=0;
			var mltSln=1;
			for (var k=0;k<fOfX.length;k++)
			{			
				sumSln+=fOfX[k]*mltSln;
				mltSln*=(arr_x_values[l]-arr_x[k]);
			}
			slnY[l]=sumSln;
		}
		//trace (sumSln);
		return slnY;
}
//newtons forwarded divided difference formula for equal intervals
function newtonsDividedDiff_equal_interval(arr_x:Array, arr_y:Array, arr_x_values:Array): Array{
		var tempFOfX:Array=new Array();
		tempFOfX=arr_y;
		var fOfX:Array=new Array();
		var slnY:Array=new Array();
		var i=0;
		//
		var xInterval=1;
		//building the table 
		//and iterating the f(x) values in differnt digrees
		do
		{
			fOfX[i]=tempFOfX[0];
			i++;
			var xIndex=0;
			for(var j=1;j<tempFOfX.length;j++)
			{
				var sln:int = (tempFOfX[j]-tempFOfX[j-1])/(arr_x[xIndex+xInterval]-arr_x[xIndex]);
				tempFOfX[xIndex]=sln;
				xIndex++;
			}
			var spliced:Array = tempFOfX.splice(xIndex,1);
			xInterval++;
		}while(tempFOfX.length>1);
		if(tempFOfX[0]!="")
		{
			fOfX[i]=tempFOfX[0];
		}
		//
		//******************************************************/
		//applying the iteratd values to the taylors series
		var h:int=arr_x[1]-arr_x[0];
		for(var l=0;l<arr_x_values.length;l++)
		{
			var u=(arr_x_values[l]-arr_x[0])/h;
			var sumSln=0;
			var mltSln=1;
			for (var k=0;k<fOfX.length;k++)
			{			
				sumSln+=fOfX[k]*(mltSln/find_factorial(k));
				mltSln*=u-k;
			}
			slnY[l]=sumSln;
		}
		//trace (sumSln);
		return slnY;
}
//cubic spline interpolation 
function cubic_spline_interpolation (arr_x:Array, arr_y:Array, arr_x_values:Array): Array{
	var slnY:Array=new Array();
	var arr_inverse:Array=new Array();
	//arr_inverse[0]=new Array();
	/*arr_inverse[1]=new Array();
	arr_inverse[1]=[0.26795,-0.0718,0.01924,-0.00515,0.00138,-0.00037,0.0001,-0.00003,0.00001,0,0,0,0,0,0,0,0,0];
	arr_inverse[2]=new Array();
	arr_inverse[2]=[-0.0718,0.28719,-0.07695,0.02062,-0.00552,0.00148,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0,0,0];
	arr_inverse[3]=new Array();
	arr_inverse[3]=[0.01924,-0.07695,0.28857,-0.07732,0.02072,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0,0];
	arr_inverse[4]=new Array();
	arr_inverse[4]=[-0.00515,0.02062,-0.07732,0.28867,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0];
	arr_inverse[5]=new Array();
	arr_inverse[5]=[0.00138,-0.00552,0.02072,-0.07735,0.28867,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0];
	arr_inverse[6]=new Array();
	arr_inverse[6]=[-0.00037,0.00148,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0];
	arr_inverse[7]=new Array();
	arr_inverse[7]=[0.0001,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0];
	arr_inverse[8]=new Array();
	arr_inverse[8]=[-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0];
	arr_inverse[9]=new Array();
	arr_inverse[9]=[0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0];
	arr_inverse[10]=new Array();
	arr_inverse[10]=[0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001];
	arr_inverse[11]=new Array();
	arr_inverse[11]=[0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003];
	arr_inverse[12]=new Array();
	arr_inverse[12]=[0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.0001];
	arr_inverse[13]=new Array();
	arr_inverse[13]=[0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00148,-0.00037];
	arr_inverse[14]=new Array();
	arr_inverse[14]=[0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28867,-0.07735,0.02072,-0.00552,0.00138];
	arr_inverse[15]=new Array();
	arr_inverse[15]=[0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28867,-0.07732,0.02062,-0.00515];
	arr_inverse[16]=new Array();
	arr_inverse[16]=[0,0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02072,-0.07732,0.28857,-0.07695,0.01924];
	arr_inverse[17]=new Array();
	arr_inverse[17]=[0,0,0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00148,-0.00552,0.02062,-0.07695,0.28719,-0.0718];
	arr_inverse[18]=new Array();
	arr_inverse[18]=[0,0,0,0,0,0,0,0,0,0.00001,-0.00003,0.0001,-0.00037,0.00138,-0.00515,0.01924,-0.0718,0.26795];*/
	//
	/*arr_inverse[1]=new Array();
	arr_inverse[1]=[0.26794,-0.07177,0.01914,-0.00478];
	arr_inverse[2]=new Array();
	arr_inverse[2]=[-0.07177,0.28708,-0.07656,0.01914];
	arr_inverse[3]=new Array();
	arr_inverse[3]=[0.01914,-0.07656,0.28708,-0.07177];
	arr_inverse[4]=new Array();
	arr_inverse[4]=[-0.00478,0.01914,-0.07177,0.26794];*/
	//trace(arr_inverse);
	arr_inverse[1]=new Array();
	arr_inverse[1]=[0.26795,-0.0718,0.01924,-0.00515,0.00138,-0.00037,0.0001,-0.00003,0.00001,0,0,0,0,0,0,0,0,0,0];
	arr_inverse[2]=new Array();
	arr_inverse[2]=[-0.0718,0.28719,-0.07695,0.02062,-0.00552,0.00148,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0,0,0,0];
	arr_inverse[3]=new Array();
	arr_inverse[3]=[0.01924,-0.07695,0.28857,-0.07732,0.02072,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0,0,0];
	arr_inverse[4]=new Array();
	arr_inverse[4]=[-0.00515,0.02062,-0.07732,0.28867,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0,0];
	arr_inverse[5]=new Array();
	arr_inverse[5]=[0.00138,-0.00552,0.02072,-0.07735,0.28867,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0,0];
	arr_inverse[6]=new Array();
	arr_inverse[6]=[-0.00037,0.00148,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0,0];
	arr_inverse[7]=new Array();
	arr_inverse[7]=[0.0001,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0,0];
	arr_inverse[8]=new Array();
	arr_inverse[8]=[-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0,0];
	arr_inverse[9]=new Array();
	arr_inverse[9]=[0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0,0];
	arr_inverse[10]=new Array();
	arr_inverse[10]=[0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001,0];
	arr_inverse[11]=new Array();
	arr_inverse[11]=[0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003,0.00001];
	arr_inverse[12]=new Array();
	arr_inverse[12]=[0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.00011,-0.00003];
	arr_inverse[13]=new Array();
	arr_inverse[13]=[0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00149,-0.0004,0.0001];
	arr_inverse[14]=new Array();
	arr_inverse[14]=[0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28868,-0.07735,0.02073,-0.00555,0.00148,-0.00037];
	arr_inverse[15]=new Array();
	arr_inverse[15]=[0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28867,-0.07735,0.02072,-0.00552,0.00138];
	arr_inverse[16]=new Array();
	arr_inverse[16]=[0,0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02073,-0.07735,0.28867,-0.07732,0.02062,-0.00515];
	arr_inverse[17]=new Array();
	arr_inverse[17]=[0,0,0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00149,-0.00555,0.02072,-0.07732,0.28857,-0.07695,0.01924];
	arr_inverse[18]=new Array();
	arr_inverse[18]=[0,0,0,0,0,0,0,0,0,0.00001,-0.00003,0.00011,-0.0004,0.00148,-0.00552,0.02062,-0.07695,0.28719,-0.0718];
	arr_inverse[19]=new Array();
	arr_inverse[19]=[0,0,0,0,0,0,0,0,0,0,0.00001,-0.00003,0.0001,-0.00037,0.00138,-0.00515,0.01924,-0.0718,0.26795];
	
	var h:Number=arr_x[1]-arr_x[0]; //interval
	var hsqure:Number=h*h;
	//
	//to find out the M values
	var arr_M:Array=new Array();
	arr_M[0]=0;
	for(var i:Number=1;i<=19;i++)
	{		
		var sum_sln:Number=0;
		for(var j:Number=0;j<19;j++)
		{
			
			var ans:Number=6*(arr_y[j]-2*arr_y[j+1]+arr_y[j+2])/hsqure;
			var mlt_sln:Number=(arr_inverse[i][j])*(6*(arr_y[j]-2*arr_y[j+1]+arr_y[j+2])/hsqure);
			sum_sln+=mlt_sln;
		}
		arr_M[i]=sum_sln;
	}
	arr_M[i]=0;
	//create equation and find out the y values
	var segment:Number;
	var a:Number;
	var b:Number;
	var c:Number;
	var d:Number;
	var xDiff:Number;
	for(var k=0;k<arr_x_values.length;k++)
	{
		segment=Math.floor((arr_x_values[k]-arr_x[0])/h);
		a=(arr_M[segment+1]-arr_M[segment])/(6*h);
		b=arr_M[segment]/2;
		c=((arr_y[segment+1]-arr_y[segment])/h)-((arr_M[segment+1]+2*arr_M[segment])*h/6);
		d=arr_y[segment];
		xDiff=arr_x_values[k]-arr_x[segment];
				slnY[k]=a*Math.pow(xDiff,3)+b*Math.pow(xDiff,2)+c*xDiff+d;
		
	}
	
	return slnY;
}
//
function find_factorial(num:Number):Number
{
	var factorial:Number = num;
	while (num > 1)
	factorial *= --num; 
	return factorial;
	// Multiply the decremented number.
}