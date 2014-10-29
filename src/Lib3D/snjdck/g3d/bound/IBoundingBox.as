package snjdck.g3d.bound
{
	import flash.geom.Vector3D;

	public interface IBoundingBox
	{
		function getProjectLen(axis:Vector3D):Number;
		function hitTestAxis(other:IBoundingBox, ab:Vector3D):Boolean;
	}
}