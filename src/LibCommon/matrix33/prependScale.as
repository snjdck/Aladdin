package matrix33
{
	import flash.geom.Matrix;

	internal function prependScale(matrix:Matrix, sx:Number, sy:Number):void
	{
		matrix.a *= sx;
		matrix.b *= sx;
		
		matrix.c *= sy;
		matrix.d *= sy;
	}
}