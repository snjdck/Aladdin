package matrix33
{
	import flash.geom.Matrix;

	public function prependTranslation(matrix:Matrix, tx:Number, ty:Number):void
	{
		matrix.tx += (matrix.a * tx) + (matrix.c * ty);
		matrix.ty += (matrix.b * tx) + (matrix.d * ty);
	}
}