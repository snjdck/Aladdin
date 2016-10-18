package snjdck.g3d.bounds
{
	import flash.geom.Vector3D;

	internal interface IBoundingBox
	{
		function getProjectLen(axis:Vector3D):Number;
		function hitTestAxis(other:IBoundingBox, ab:Vector3D):Boolean;
	}
}