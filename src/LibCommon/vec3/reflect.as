package vec3
{
	import flash.geom.Vector3D;

	public function reflect(dirIn:Vector3D, normal:Vector3D, dirOut:Vector3D):void
	{
		normal.normalize();
		var len:Number = dotProd(dirIn, normal);
		normal.scaleBy(-2 * len);
		vec3.add(dirIn, normal, dirOut);
	}
}