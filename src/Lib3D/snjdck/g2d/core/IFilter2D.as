package snjdck.g2d.core
{
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.filter.IFragmentFilter;

	public interface IFilter2D extends IFragmentFilter
	{
		function draw(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void;
	}
}