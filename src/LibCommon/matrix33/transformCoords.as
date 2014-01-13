package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	[Inline]
	public function transformCoords(matrix:Matrix, x:Number, y:Number, output:Point):void
	{
		output.x = (matrix.a * x) + (matrix.c * y) + matrix.tx;
		output.y = (matrix.b * x) + (matrix.d * y) + matrix.ty;
	}
}