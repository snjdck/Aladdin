package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.g3d.asset.IGpuContext;

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
		
		override public function draw(render2d:Render2D, context3d:IGpuContext):void
		{
			if(null == texture || false == visible){
				return;
			}
			
			if(false == opaque && 0 == alpha){
				return;
			}
			
			render2d.draw(context3d, this, texture);
		}
	}
}