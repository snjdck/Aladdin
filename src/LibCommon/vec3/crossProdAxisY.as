package vec3
{
	import flash.geom.Vector3D;

	[Inline]
	public function crossProdAxisY(v:Vector3D, result:Vector3D):void
	{
		result.setTo(-v.z, 0, v.x);
	}
}