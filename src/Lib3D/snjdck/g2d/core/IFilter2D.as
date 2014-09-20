package snjdck.g2d.core
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.filter.IFragmentFilter;
	import snjdck.gpu.render.GpuRender;

	public interface IFilter2D extends IFragmentFilter
	{
		function draw(target:DisplayObject2D, render:GpuRender, context3d:GpuContext):void;
	}
}