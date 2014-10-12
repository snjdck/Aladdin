package vec3
{
	import flash.geom.Vector3D;

	public function reflect(dirIn:Vector3D, normal:Vector3D, dirOut:Vector3D):void
	{
		var len:Number = dotProd(dirIn, normal) * 2;
		dirOut.x = dirIn.x - normal.x * len;
		dirOut.y = dirIn.y - normal.y * len;
		dirOut.z = dirIn.z - normal.z * len;
	}
}