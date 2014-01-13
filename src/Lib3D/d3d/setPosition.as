package d3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;

	public function setPosition(target:Object3D, value:Vector3D):void
	{
		moveTo(target, value.x, value.y, value.z);
	}
}