package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProd(va:Vector3D, vb:Vector3D, result:Vector3D):void
	{
		result.x = (va.y * vb.z) - (va.z * vb.y);
		result.y = (va.z * vb.x) - (va.x * vb.z);
		result.z = (va.x * vb.y) - (va.y * vb.x);
	}
}