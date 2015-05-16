package matrix33
{
	import flash.geom.Matrix;

	/**
	 * prepend a skew transformation to a matrix, with angles in radians.
	 */
	internal function prependSkew(matrix:Matrix, skewX:Number, skewY:Number):void
	{
		var sinX:Number = Math.sin(skewX);
		var cosX:Number = Math.cos(skewX);
		var sinY:Number = Math.sin(skewY);
		var cosY:Number = Math.cos(skewY);
		
		var a:Number    = matrix.a;
		var b:Number    = matrix.b;
		var c:Number    = matrix.c;
		var d:Number    = matrix.d;
		var tx:Number   = matrix.tx;
		var ty:Number   = matrix.ty;
		
		matrix.a = a * cosY + c * sinY;
		matrix.b = b * cosY + d * sinY;
		matrix.c = c * cosX + a * sinX;
		matrix.d = d * cosX + b * sinX;
	}
}