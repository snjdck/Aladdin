package snjdck.g2d.core
{
	import snjdck.gpu.asset.GpuContext;

	public interface IRender
	{
		function setScreenSize(width:int, height:int):void;
		function uploadProjectionMatrix(context3d:GpuContext):void;
	}
}