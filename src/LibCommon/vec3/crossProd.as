package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProd(va:Vector3D, vb:Vector3D, result:Vector3D):void
	{
		var tx:* = (va.y * vb.z) - (va.z * vb.y);
		var ty:* = (va.z * vb.x) - (va.x * vb.z);
		var tz:* = (va.x * vb.y) - (va.y * vb.x);
		result.x = tx;
		result.y = ty;
		result.z = tz;
	}
}