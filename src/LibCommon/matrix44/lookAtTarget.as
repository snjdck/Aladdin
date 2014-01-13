package matrix44
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public function lookAtTarget(eye:Vector3D, at:Vector3D, up:Vector3D, output:Matrix3D):void
	{
		lookAtDirection(eye, at.subtract(eye), up, output);
	}
}