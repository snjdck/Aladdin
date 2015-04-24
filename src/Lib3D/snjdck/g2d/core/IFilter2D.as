package snjdck.g2d.core
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;

	public interface IFilter2D
	{
		function draw(target:DisplayObject2D, render2d:Render2D, context3d:GpuContext):void;
		function renderFilter(texture:IGpuTexture, render2d:Render2D, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void;
		function get marginX():int;
		function get marginY():int;
	}
}