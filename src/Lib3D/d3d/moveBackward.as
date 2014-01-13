package d3d
{
	import snjdck.g3d.core.Object3D;

	public function moveBackward(target:Object3D, distance:Number):void
	{
		moveForward(target, -distance);
	}
}