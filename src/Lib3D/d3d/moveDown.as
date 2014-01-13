package d3d
{
	import snjdck.g3d.core.Object3D;

	public function moveDown(target:Object3D, distance:Number):void
	{
		moveUp(target, -distance);
	}
}