package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisZ(v:Vector3D, result:Vector3D):void
	{
		result.setTo(v.y, -v.x, 0);
	}
}