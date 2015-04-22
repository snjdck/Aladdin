package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class Image extends DisplayObject2D
	{
		private var _texture:Texture2D;
		private var _opaque:Boolean;
		private const opaqueArea:Rectangle = new Rectangle();
		
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
		
		override public function preDrawDepth(render:Render2D, context3d:GpuContext):void
		{
			if(texture.scale9 != null){
				var v:Vector.<Number> = texture.scale9;
				render.drawLocalRect(context3d, prevWorldMatrix,
					v[0],v[1],
					width - (v[0] + v[2]),
					height - (v[1] + v[3])
				);
			}
		}
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			render.drawImage(context3d, this, texture);
		}
		
		public function set opaque(value:Boolean):void
		{
			_opaque = value;
		}
		
		public function setOpaqueArea(leftMargin:int, topMargin:int, rightMargin:int, bottomMargin:int):void
		{
			_opaque = false;
			opaqueArea.setTo(leftMargin, topMargin, rightMargin, bottomMargin);
		}
	}
}