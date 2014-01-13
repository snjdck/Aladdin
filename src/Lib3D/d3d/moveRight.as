package d3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Object3D;

	public function moveRight(target:Object3D, distance:Number):void
	{
		target.translateLocal(Vector3D.X_AXIS, distance);
	}
}