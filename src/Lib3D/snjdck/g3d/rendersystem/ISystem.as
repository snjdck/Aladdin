package snjdck.g3d.rendersystem
{
	import snjdck.gpu.asset.GpuContext;

	public interface ISystem
	{
		function onDrawBegin(context3d:GpuContext):void;
		function render(context3d:GpuContext, item:Object):void;
	}
}