package snjdck.gpu.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;

	public class FragmentFilter
	{
		static protected const vertexData:VertexData = new VertexData();
		protected const bounds:Rectangle = new Rectangle();
		
		protected var image:GpuRenderTarget;
		public var mode:String;
		
		public function FragmentFilter(){}
		
		private function drawTarget(target:DisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.pushScreen();
			render.r2d.setScreenSize(bounds.width, bounds.height);
			render.r2d.offset(-bounds.x, -bounds.y);
			render.r2d.uploadProjectionMatrix(context3d);
			
			context3d.renderTarget = image;
			image.clear(context3d);
			
			target.draw(render, context3d);
			render.r2d.drawEnd(context3d);
			
			render.r2d.popScreen();
		}
		
		final public function draw(target:DisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.drawEnd(context3d);
			const prevRenderTarget:GpuRenderTarget = context3d.renderTarget;
			
			onDrawBegin(target);
			drawTarget(target, render, context3d);
			
			bounds.x += render.r2d.offsetX;
			bounds.y += render.r2d.offsetY;
			render.r2d.offset(0, 0);
			
			if(FragmentFilterMode.ABOVE == mode){
				render.r2d.uploadProjectionMatrix(context3d);
				vertexData.reset(bounds.x, bounds.y, bounds.width, bounds.height);
				context3d.renderTarget = prevRenderTarget;
				render.r2d.drawTexture(context3d, vertexData, image);
				render.r2d.drawEnd(context3d);
			}
			
			drawFilter(prevRenderTarget, render, context3d);
			
			render.r2d.drawBegin(context3d);
			
			if(FragmentFilterMode.BELOW == mode){
				render.r2d.drawTexture(context3d, vertexData, image);
				render.r2d.drawEnd(context3d);
			}
			
			onDrawEnd();
		}
		
		protected function onDrawBegin(target:IDisplayObject2D):void{}
		protected function onDrawEnd():void{}
		protected function drawFilter(prevRenderTarget:GpuRenderTarget, render:GpuRender, context3d:GpuContext):void{}
	}
}