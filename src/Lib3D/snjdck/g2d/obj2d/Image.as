package snjdck.g2d.obj2d
{
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.OpaqueAreaCollector;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class Image extends DisplayObject2D
	{
		private var _texture:Texture2D;
		private var _opaque:Boolean;
		private const opaqueArea:Rectangle = new Rectangle();
		
		public const colorTransform:ColorTransform = new ColorTransform();
		
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
				width = texture.width;
				height = texture.height;
			}else{
				width = 0;
				height = 0;
			}
		}
		
		override public function isVisible():Boolean
		{
			return super.isVisible() && (texture != null);
		}
		
		override ns_g2d function collectOpaqueArea(collector:OpaqueAreaCollector):void
		{
			if(clipContent){
				return;
			}
			if(texture.scale9 != null){
				var v:Vector.<Number> = texture.scale9;
				collector.add(worldTransform,
					v[0],v[1],
					width - (v[0] + v[2]),
					height - (v[1] + v[3])
				);
			}
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			render2d.drawImage(context3d, this, texture, colorTransform);
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
		
		public function get alpha():Number
		{
			return colorTransform.alphaMultiplier;
		}
		
		public function set alpha(value:Number):void
		{
			colorTransform.alphaMultiplier = value;
		}
		
		public function setForegroundColor(color:uint, alpha:Number):void
		{
			gpuColor.rgb = color;
			colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1 - alpha;
			colorTransform.redOffset = gpuColor.red * alpha;
			colorTransform.greenOffset = gpuColor.green * alpha;
			colorTransform.blueOffset = gpuColor.blue * alpha;
		}
		
		public function clearForegroundColor():void
		{
			colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
			colorTransform.redOffset = colorTransform.greenOffset = colorTransform.blueOffset = 0;
		}
		
		static private const gpuColor:GpuColor = new GpuColor();
	}
}