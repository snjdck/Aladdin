package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function dotProd(va:Vector3D, vb:Vector3D):Number
	{
		return (va.x * vb.x) + (va.y * vb.y) + (va.z * vb.z);
	}
}