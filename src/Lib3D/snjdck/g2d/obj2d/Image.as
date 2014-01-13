package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.Collector2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.DrawUnit2D;
	import snjdck.g2d.texture.Texture2D;

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
		
		override public function collectDrawUnits(collector:Collector2D):void
		{
			if(null == texture || false == visible){
				return;
			}
			
			if(false == opaque && 0 == alpha){
				return;
			}
			
			var drawUnit:DrawUnit2D = collector.getFreeDrawUnit();
			
			drawUnit.target = this;
			drawUnit.texture = texture;
			
			collector.addDrawUnit(drawUnit);
		}
	}
}