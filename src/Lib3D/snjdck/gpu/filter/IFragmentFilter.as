package snjdck.gpu.filter
{
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;

	public interface IFragmentFilter
	{
		function render(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void;
		function get marginX():int;
		function get marginY():int;
	}
}