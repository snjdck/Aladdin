package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;

	internal class RenderRegion
	{
		public var renderTarget:GpuRenderTarget;
		public var rect:Rectangle;
		
		public function RenderRegion()
		{
		}
		
		public function drawToSelf(gpuTexture:IGpuTexture, render2d:Render2D, context3d:GpuContext):void
		{
			context3d.renderTarget = renderTarget;
			context3d.setScissorRect(rect);
			if(!renderTarget.hasCleared()){
				context3d.clearStencil();
			}
//			context3d.texture = gpuTexture;
			render2d.pushScreen(renderTarget.width, renderTarget.height);
			render2d.drawTexture(context3d, gpuTexture);
//			render2d.drawWorldRect(context3d, 0, 0, rect.width, rect.height);
			render2d.popScreen();
		}
	}
}