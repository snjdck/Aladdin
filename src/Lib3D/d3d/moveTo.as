package d3d
{
	import snjdck.g3d.core.Object3D;

	public function moveTo(target:Object3D, px:Number, py:Number, pz:Number):void
	{
		target.x = px;
		target.y = py;
		target.z = pz;
	}
}