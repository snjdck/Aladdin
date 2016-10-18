package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	[Inline]
	public function extractPosition(matrix:Matrix3D, output:Vector3D):void
	{
		matrix.copyColumnTo(3, output);
	}
}