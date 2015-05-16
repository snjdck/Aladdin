package matrix33
{
	import flash.geom.Matrix;

	internal function invert(matrix:Matrix, output:Matrix):void
	{
		var a:Number    = matrix.a;
		var b:Number    = matrix.b;
		var c:Number    = matrix.c;
		var d:Number    = matrix.d;
		var tx:Number   = matrix.tx;
		var ty:Number   = matrix.ty;
		
		var factor:Number = a * d - b * c;
		
		if(0 == factor){
			output.a = output.d = 1;
			output.b = output.c = output.tx = output.ty = 0;
			return;
		}
		
		if(0 == c && 0 == b){//rotation == 0
			output.b = output.c = 0;
			output.a = 1 / a;
			output.d = 1 / d;
			output.tx = output.a * -tx;
			output.ty = output.d * -ty;
			return;
		}
		
		factor = 1 / factor;
		
		output.a = d * factor;
		output.d = a * factor;
		output.b = b * -factor;
		output.c = c * -factor;
		output.tx = -(tx * output.a  + ty * output.c);
		output.ty = -(tx * output.b  + ty * output.d);
	}
}