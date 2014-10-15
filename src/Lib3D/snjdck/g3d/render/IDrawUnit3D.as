package snjdck.g3d.render
{
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		function draw(render3d:Render3D, camera3d:CameraUnit3D, collector:DrawUnitCollector3D, context3d:GpuContext):void;
		function isOpaque():Boolean;
	}
}