package snjdck.g2d.core
{
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;

	public interface IFilter2D
	{
		function draw(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void;
	}
}