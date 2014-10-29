package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisZ(v:Vector3D, result:Vector3D):void
	{
		result.x = v.y;
		result.y = -v.x;
		result.z = 0;
	}
}