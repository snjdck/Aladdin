package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisX(v:Vector3D, result:Vector3D):void
	{
		result.x = 0;
		result.y = v.z;
		result.z = -v.y;
	}
}