package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.gpu.render.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;

	public class Filter2D implements IFilter2D
	{
		private const bounds:Rectangle = new Rectangle();
		private var imageBuffer:GpuRenderTarget;
		
		public function Filter2D(){}
		
		public function draw(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			const prevProgram:GpuProgram = context3d.program;
			
			calcBounds(target);
			imageBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			initImageBuffer(target, render, context3d);
			
			bounds.x += render.r2d.offsetX;
			bounds.y += render.r2d.offsetY;
			render.r2d.offset(0, 0);
			
			renderFilter(imageBuffer, render, context3d, prevRenderTarget, bounds.x, bounds.y);
			
			imageBuffer.dispose();
			
			context3d.program = prevProgram;
		}
		
		private function calcBounds(target:IDisplayObject2D):void
		{
			target.getBounds(null, bounds);
			bounds.inflate(marginX, marginY);
		}
		
		private function initImageBuffer(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.pushScreen(bounds.width, bounds.height);
			render.r2d.offset(-bounds.x, -bounds.y);
			
			context3d.renderTarget = imageBuffer;
			imageBuffer.clear(context3d);
			
			target.draw(render, context3d);
			
			render.r2d.popScreen();
		}
		
		public function renderFilter(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
		}
		
		public function get marginX():int
		{
			return 0;
		}
		
		public function get marginY():int
		{
			return 0;
		}
	}
}