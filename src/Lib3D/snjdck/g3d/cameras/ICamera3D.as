package snjdck.g3d.cameras
{
	import snjdck.gpu.asset.GpuContext;

	public interface ICamera3D
	{
		function getViewFrustum():IViewFrustum;
		function setScreenSize(width:int, height:int):void;
		function draw(context3d:GpuContext):void;
	}
}