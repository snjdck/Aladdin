package snjdck.g2d.core
{
	import snjdck.g3d.asset.IGpuContext;

	public interface IRender
	{
		function setScreenSize(width:int, height:int):void;
		function uploadProjectionMatrix(context3d:IGpuContext):void;
	}
}