package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		function draw(cameraWorldMatrix:Matrix3D, context3d:GpuContext):void;
		function isOpaque():Boolean;
		function getAABB():AABB;
	}
}