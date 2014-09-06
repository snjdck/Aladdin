package snjdck.g2d.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;

	public class Filter2D implements IFilter2D
	{
		protected const bounds:Rectangle = new Rectangle();
		protected var image:GpuRenderTarget;
		
		public function Filter2D(){}
		
		private function drawTarget(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.pushScreen();
			render.r2d.setScreenSize(bounds.width, bounds.height);
			render.r2d.offset(-bounds.x, -bounds.y);
			render.r2d.uploadProjectionMatrix(context3d);
			
			context3d.renderTarget = image;
			image.clear(context3d);
			
			target.draw(render, context3d);
			
			render.r2d.popScreen();
		}
		
		final public function draw(target:IDisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			target.getBounds(null, bounds);
			adjustBounds();
			
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			
			onDrawBegin();
			drawTarget(target, render, context3d);
			
			bounds.x += render.r2d.offsetX;
			bounds.y += render.r2d.offsetY;
			render.r2d.offset(0, 0);
			
//			if(FragmentFilterMode.ABOVE == mode){
//				render.r2d.uploadProjectionMatrix(context3d);
//				vertexData.reset(bounds.x, bounds.y, bounds.width, bounds.height);
//				context3d.renderTarget = prevRenderTarget;
//				render.r2d.drawTexture(context3d, vertexData, image);
//				render.r2d.drawEnd(context3d);
//			}
			
			drawFilter(prevRenderTarget, render, context3d);
			
			render.r2d.drawBegin(context3d);
			
//			if(FragmentFilterMode.BELOW == mode){
//				render.r2d.drawTexture(context3d, vertexData, image);
//				render.r2d.drawEnd(context3d);
//			}
			
			onDrawEnd();
		}
		
		protected function adjustBounds():void{};
		protected function onDrawBegin():void{}
		protected function onDrawEnd():void{}
		protected function drawFilter(prevRenderTarget:GpuRenderTarget, render:GpuRender, context3d:GpuContext):void{}
		
		public function get marginX():int
		{
			return 0;
		}
		
		public function get marginY():int
		{
			return 0;
		}
		
		public function render(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
		}
	}
}