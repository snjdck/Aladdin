package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function subtract(va:Vector3D, vb:Vector3D, result:Vector3D):void
	{
		result.x = va.x - vb.x;
		result.y = va.y - vb.y;
		result.z = va.z - vb.z;
	}
}