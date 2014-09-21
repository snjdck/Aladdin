package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function transformVector(matrix:Matrix3D, input:Vector3D, output:Vector3D):void
	{
		transformCoords(matrix, input.x, input.y, input.z, output);
	}
}