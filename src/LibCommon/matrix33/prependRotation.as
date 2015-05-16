package matrix33
{
	import flash.geom.Matrix;

	/**
	 * @param angle The rotation angle in radians
	 */	
	internal function prependRotation(matrix:Matrix, angle:Number):void
	{
		var sin:Number = Math.sin(angle);
		var cos:Number = Math.cos(angle);
		
		var a:Number = matrix.a;
		var b:Number = matrix.b;
		var c:Number = matrix.c;
		var d:Number = matrix.d;
		
		matrix.a = a * cos + c * sin;
		matrix.b = b * cos + d * sin;
		matrix.c = c * cos - a * sin;
		matrix.d = d * cos - b * sin;
	}
}