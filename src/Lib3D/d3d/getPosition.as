package d3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;

	public function getPosition(target:Object3D):Vector3D
	{
		return new Vector3D(target.x, target.y, target.z);
	}
}