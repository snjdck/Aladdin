package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	
	use namespace ns_g2d;

	/**
	 * 
	 * @author Alex
	 * 当需要多个RenderTarget时,可以考虑申请一个大的RenderTarget,然后通过sessionRect来分割
	 */	
	internal class Filter2D implements IFilter2D
	{
		static private const bounds:Rectangle = new Rectangle();
		private var imageBuffer:GpuRenderTarget;
		
		public function Filter2D(){}
		
		public function draw(target:DisplayObject2D, render:Render2D, context3d:GpuContext):void
		{
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			context3d.save();
			
			target.getBounds(null, bounds);
			var boundsX:Number = bounds.x;
			var boundsY:Number = bounds.y;
			
			imageBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			imageBuffer.setRenderToSelfAndClear(context3d);
			
			render.pushScreen(bounds.width, bounds.height, -boundsX, -boundsY);
			target.draw(render, context3d);
			render.popScreen();
			
			boundsX += render.offsetX;
			boundsY += render.offsetY;
			render.offset(0, 0);
			
			renderFilter(imageBuffer, render, context3d, prevRenderTarget, boundsX, boundsY);
			
			imageBuffer.dispose();
			
			context3d.restore();
		}
		
		public function renderFilter(texture:IGpuTexture, render:Render2D, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void{}
		public function get marginX():int{ return 0; }
		public function get marginY():int{ return 0; }
	}
}