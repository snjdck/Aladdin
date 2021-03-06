package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function interpolate(va:Vector3D, vb:Vector3D, f:Number, result:Vector3D):void
	{
		result.x = va.x + (vb.x - va.x) * f;
		result.y = va.y + (vb.y - va.y) * f;
		result.z = va.z + (vb.z - va.z) * f;
	}
}