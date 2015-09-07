package matrix33
{
	import flash.geom.Matrix;

	[Inline]
	public function hasRotation(matrix:Matrix):Boolean
	{
		return !(0 == matrix.b && 0 == matrix.c);
	}
}