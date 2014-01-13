package d3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;

	public function moveUp(target:Object3D, distance:Number):void
	{
		target.translateLocal(Vector3D.Y_AXIS, distance);
	}
}