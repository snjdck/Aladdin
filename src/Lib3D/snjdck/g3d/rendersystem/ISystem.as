package snjdck.g3d.rendersystem
{
	import snjdck.gpu.asset.GpuContext;

	public interface ISystem
	{
		function activePass(context3d:GpuContext, renderType:int):void;
		function render(context3d:GpuContext, item:Object):void;
	}
}