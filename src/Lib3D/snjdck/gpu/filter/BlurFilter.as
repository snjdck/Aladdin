package snjdck.gpu.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;

	public class BlurFilter
	{
		static private const _vertexData:VertexData = new VertexData();
		
		private var frontBuffer:GpuRenderTarget;
		private var backBuffer:GpuRenderTarget;
		
		public function BlurFilter()
		{
		}
		
		public function drawBegin(texture:GpuRenderTarget, render:GpuRender, context3d:GpuContext):void
		{
			frontBuffer = new GpuRenderTarget(texture.width, texture.height);
			backBuffer = texture;
			
			_vertexData.reset(0, 0, texture.width, texture.height);
			
			render.r2d.pushScreen();
			render.r2d.setScreenSize(texture.width, texture.height);
			render.r2d.uploadProjectionMatrix(context3d);
			render.r2d.popScreen();
			
			for(var i:int=0; i<10; i++)
			{
				var tempBuffer:GpuRenderTarget = frontBuffer;
				frontBuffer = backBuffer;
				backBuffer = tempBuffer;
				
				context3d.setRenderToTexture(backBuffer);
				backBuffer.clear(context3d);
				
				render.r2d.drawTexture(context3d, _vertexData, frontBuffer);
				render.r2d.drawEnd(context3d);
			}
		}
		
		public function drawEnd(bounds:Rectangle, render:GpuRender, context3d:GpuContext):void
		{
			_vertexData.reset(bounds.x, bounds.y, bounds.width, bounds.height);
			
			render.r2d.drawTexture(context3d, _vertexData, backBuffer);
			render.r2d.drawEnd(context3d);
			
			frontBuffer.dispose();
			backBuffer.dispose();
		}
	}
}