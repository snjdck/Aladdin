package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.gpu.render.GpuRender;
	import snjdck.gpu.asset.GpuContext;

	public class Image extends DisplayObject2D
	{
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
				_width = texture.width;
				_height = texture.height;
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
			render.r2d.drawImage(context3d, this, texture);
		}
	}
}