package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.support.VertexData;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;

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
		
		override public function hasVisibleArea():Boolean
		{
			return super.hasVisibleArea() && (texture != null);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			_vertexData.reset(0, 0, width, height);
			_texture.adjustVertexData(_vertexData);
			_vertexData.transformPosition(worldMatrix);
			_vertexData.alpha = worldAlpha;
			
			render.r2d.drawTexture(context3d, _vertexData, texture.gpuTexture);
		}
		
		override public function getBounds(targetSpace:IDisplayObject2D, result:Rectangle):void
		{
			vertexData.reset(0, 0, width, height);
			_texture.adjustVertexData(_vertexData);
			calcSpaceTransform(targetSpace, tempMatrix1);
			vertexData.getBounds(tempMatrix1, result);
		}
	}
}