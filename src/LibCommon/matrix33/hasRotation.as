package matrix33
{
	import flash.geom.Matrix;

	[Inline]
	public function hasRotation(matrix:Matrix):Boolean
	{
		return (matrix.b != 0) || (matrix.c != 0);
	}
}