package snjdck.g2d.obj2d
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.render.Render2D;
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
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			render.pushMatrix(transform);
			render.drawImage(context3d, this, texture);
			render.popMatrix();
		}
	}
}