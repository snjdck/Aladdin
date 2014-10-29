package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisY(v:Vector3D, result:Vector3D):void
	{
		result.x = -v.z;
		result.y = 0;
		result.z = v.x;
	}
}