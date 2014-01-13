package snjdck.g3d.asset
{
	import flash.display3D.Context3D;
	import flash.lang.IDimension;

	public interface IRenderTarget extends IDimension
	{
		function setRenderTarget(context3d:Context3D):void;
		function clear(context3d:IGpuContext):void;
		
		function onFrameBegin(context3d:IGpuContext):void;
		function set backgroundColor(color:uint):void;
	}
}