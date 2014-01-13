package matrix33
{
	import flash.geom.Matrix;

	public function appendScale(matrix:Matrix, sx:Number, sy:Number):void
	{
		matrix.a  *= sx;
		matrix.c  *= sx;
		matrix.tx *= sx;
		
		matrix.b  *= sy;
		matrix.d  *= sy;
		matrix.ty *= sy;
	}
}