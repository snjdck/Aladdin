package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.texture.SubTexture2D;
	import snjdck.g2d.texture.Texture2D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	
	final public class Scale9Image extends DisplayObject2D
	{
		private var _texture:Texture2D;
		private const _scale9Grid:Rectangle = new Rectangle();
		
		private var topLeft:Image;
		private var top:Image;
		private var topRight:Image;
		
		private var left:Image;
		private var center:Image;
		private var right:Image;
		
		private var bottomLeft:Image;
		private var bottom:Image;
		private var bottomRight:Image;
		
		public function Scale9Image(texture:Texture2D, scale9Grid:Rectangle)
		{
			this.texture = texture;
			this.scale9Grid = scale9Grid || new Rectangle(0, 0, texture.width, texture.height);
			init();
		}
		
		private function init():void
		{
			const x1:Number = scale9Grid.x;
			const x2:Number = scale9Grid.right;
			const x3:Number = texture.width;
			
			const y1:Number = scale9Grid.y;
			const y2:Number = scale9Grid.bottom;
			const y3:Number = texture.height;
			
			topLeft		= createGridImage(0,  0, x1, y1);
			top			= createGridImage(x1, 0, x2, y1);
			topRight	= createGridImage(x2, 0, x3, y1);
			
			left		= createGridImage(0,  y1, x1, y2);
			center		= createGridImage(x1, y1, x2, y2);
			right		= createGridImage(x2, y1, x3, y2);
			
			bottomLeft	= createGridImage(0,  y2, x1, y3);
			bottom		= createGridImage(x1, y2, x2, y3);
			bottomRight	= createGridImage(x2, y2, x3, y3);
			
			top.x = x1;
			center.x = x1;
			bottom.x = x1
			
			topRight.x = x2;
			right.x = x2;
			bottomRight.x = x2;
			
			left.y = y1;
			center.y = y1;
			right.y = y1;
			
			bottomLeft.y = y2;
			bottom.y = y2;
			bottomRight.y = y2;
			
		}
		
		private function createGridImage(regionX:Number, regionY:Number, regionRight:Number, regionBottom:Number):Image
		{
			return new Image(new SubTexture2D(texture, new Rectangle(regionX, regionY, regionRight-regionX, regionBottom-regionY)));
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

		public function get scale9Grid():Rectangle
		{
			return _scale9Grid.clone();
		}

		public function set scale9Grid(value:Rectangle):void
		{
			_scale9Grid.copyFrom(value);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			const centerWidth:Number = width - (texture.width - scale9Grid.width);
			const rightX:Number = scale9Grid.x + centerWidth;
			
			top.width = centerWidth;
			center.width = centerWidth;
			bottom.width = centerWidth;
			
			topRight.x = rightX;
			right.x = rightX;
			bottomRight.x = rightX;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			const centerHeight:Number = height - (texture.height - scale9Grid.height);
			const bottomY:Number = scale9Grid.y + centerHeight;
			
			left.height = centerHeight;
			center.height = centerHeight;
			right.height = centerHeight;
			
			bottomLeft.y = bottomY;
			bottom.y = bottomY;
			bottomRight.y = bottomY;
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			if(false == visible){
				return;
			}
			
			topLeft.draw(render, context3d);
			top.draw(render, context3d);
			topRight.draw(render, context3d);
			
			left.draw(render, context3d);
			center.draw(render, context3d);
			right.draw(render, context3d);
			
			bottomLeft.draw(render, context3d);
			bottom.draw(render, context3d);
			bottomRight.draw(render, context3d);
		}
		/*
		override public function collectDrawUnits(collector:Collector2D):void
		{
			if(false == visible){
				return;
			}
			
			topLeft.collectDrawUnits(collector);
			top.collectDrawUnits(collector);
			topRight.collectDrawUnits(collector);
			
			left.collectDrawUnits(collector);
			center.collectDrawUnits(collector);
			right.collectDrawUnits(collector);
			
			bottomLeft.collectDrawUnits(collector);
			bottom.collectDrawUnits(collector);
			bottomRight.collectDrawUnits(collector);
		}
		*/
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			
			topLeft.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			top.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			topRight.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			
			left.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			center.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			right.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			
			bottomLeft.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			bottom.onUpdate(timeElapsed, worldMatrix, worldAlpha);
			bottomRight.onUpdate(timeElapsed, worldMatrix, worldAlpha);
		}
	}
}