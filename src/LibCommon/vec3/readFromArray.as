package vec3
{
	import flash.geom.Vector3D;

	/** @return result */
	public function readFromArray(buffer:Object, fromIndex:int, result:Vector3D):Vector3D
	{
		result.x = buffer[fromIndex];
		result.y = buffer[fromIndex+1];
		result.z = buffer[fromIndex+2];
		return result;
	}
}