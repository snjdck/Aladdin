package snjdck.g3d.asset
{
	import flash.display3D.Context3D;
	import flash.lang.IDisposable;

	public interface IGpuAsset extends IDisposable
	{
		function freeGpuMemory():void;
		function getRawGpuAsset(context3d:Context3D):*;
	}
}