package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	[Inline]
	public function transformVectorDelta(matrix:Matrix3D, input:Vector3D, output:Vector3D):void
	{
		transformCoordsDelta(matrix, input.x, input.y, input.z, output);
	}
}