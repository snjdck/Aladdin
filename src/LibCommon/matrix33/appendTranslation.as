package matrix33
{
	import flash.geom.Matrix;

	internal function appendTranslation(matrix:Matrix, tx:Number, ty:Number):void
	{
		matrix.tx += tx;
		matrix.ty += ty;
	}
}