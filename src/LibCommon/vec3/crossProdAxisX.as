package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisX(v:Vector3D, result:Vector3D):void
	{
		result.setTo(0, v.z, -v.y);
	}
}