package d3d
{
	import snjdck.g3d.core.Object3D;

	public function moveLeft(target:Object3D, distance:Number):void
	{
		moveRight(target, -distance);
	}
}