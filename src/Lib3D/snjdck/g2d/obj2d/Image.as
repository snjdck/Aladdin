package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.support.VertexData;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.filter.BlurFilter;

	public class Image extends DisplayObject2D
	{
		static private const _vertexData:VertexData = new VertexData();
		private var _texture:Texture2D;
		
		public function Image(texture:Texture2D)
		{
			this.texture = texture;
		}
		
		public function get texture():Texture2D
		{
			return _texture;
		}

		public function set texture(value:Texture2D):void
		{
			_texture = value;
			
			if(texture){
				var frame:Rectangle = texture.frame;
				if(frame){
					_width = frame.width;
					_height = frame.height;
				}else{
					_width = texture.width;
					_height = texture.height;
				}
			}else{
				_width = _height = 0;
			}
		}
		
		private var blur:BlurFilter = new BlurFilter();
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			if(null == texture || false == visible){
				return;
			}
			
			if(0 == alpha){
				return;
			}
			
			if(filter){
				render.r2d.drawEnd(context3d);
				getBounds(parent, bounds);
				
				render.r2d.pushScreen();
				render.r2d.setScreenSize(bounds.width, bounds.height);
				render.r2d.offset(-bounds.x, -bounds.y);
				render.r2d.uploadProjectionMatrix(context3d);
				render.r2d.popScreen();
				
				var rt:GpuRenderTarget = new GpuRenderTarget(bounds.width, bounds.height);
				
				context3d.pushRenderTarget(rt);
				rt.clear(context3d);
				
				drawImpl(render, context3d);
				render.r2d.drawEnd(context3d);
				
				blur.drawBegin(rt, render, context3d);
				
				context3d.popRenderTarget();
				render.r2d.uploadProjectionMatrix(context3d);
				
				blur.drawEnd(bounds, render, context3d);
			}else{
				drawImpl(render, context3d);
			}
		}
		
		private const bounds:Rectangle = new Rectangle();
		
		private function drawImpl(render:GpuRender, context3d:GpuContext):void
		{
			_vertexData.reset(0, 0, width, height);
			_texture.adjustVertexData(_vertexData);
			_vertexData.transformPosition(worldMatrix);
			_vertexData.color = color;
			_vertexData.alpha = worldAlpha;
			
			render.r2d.drawTexture(context3d, _vertexData, texture.gpuTexture);
		}
	}
}