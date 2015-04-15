package snjdck.g3d.render
{
	import snjdck.g3d.bound.AABB;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		function draw(camera3d:CameraUnit3D, collector:DrawUnitCollector3D, context3d:GpuContext):void;
		function isOpaque():Boolean;
		function getAABB():AABB;
	}
}