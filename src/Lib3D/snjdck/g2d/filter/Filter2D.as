package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.render.GpuRender;

	public class Filter2D implements IFilter2D
	{
		static private const bounds:Rectangle = new Rectangle();
		private var imageBuffer:GpuRenderTarget;
		
		public function Filter2D(){}
		
		public function draw(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			const prevProgram:GpuProgram = context3d.program;
			
			target.getBounds(null, bounds);
			var boundsX:Number = bounds.x;
			var boundsY:Number = bounds.y;
			
			imageBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			imageBuffer.setRenderToSelfAndClear(context3d);
			
			render.r2d.pushScreen(bounds.width, bounds.height, -boundsX, -boundsY);
			target.draw(render, context3d);
			render.r2d.popScreen();
			
			boundsX += render.r2d.offsetX;
			boundsY += render.r2d.offsetY;
			render.r2d.offset(0, 0);
			
			renderFilter(imageBuffer, render, context3d, prevRenderTarget, boundsX, boundsY);
			
			imageBuffer.dispose();
			
			context3d.program = prevProgram;
		}
		
		public function renderFilter(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void{}
		public function get marginX():int{ return 0; }
		public function get marginY():int{ return 0; }
	}
}