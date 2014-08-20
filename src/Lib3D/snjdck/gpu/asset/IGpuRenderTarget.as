package snjdck.gpu.asset
{
	import flash.lang.IDimension;

	public interface IGpuRenderTarget extends IDimension
	{
		function setRenderToSelf(context3d:GpuContext):void;
		function clear(context3d:GpuContext):void;
		
		function get antiAlias():int;
		function set backgroundColor(value:uint):void;
	}
}