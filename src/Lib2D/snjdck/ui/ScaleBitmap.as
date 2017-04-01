package snjdck.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.d3.createMeshIndices;
	
	public class ScaleBitmap extends Sprite
	{
		static private const Indices:Vector.<int> = new Vector.<int>();
		createMeshIndices(4, 4, Indices);
		
		private var _bitmapData:BitmapData;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _vertices:Vector.<Number>;
		private var _uvtData:Vector.<Number>;
		
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		
		public function ScaleBitmap()
		{
			_width = super.width;
			_height = super.height;
			_bitmapData = (removeChildAt(0) as Bitmap).bitmapData;
			
			_left = scale9Grid.x;
			_right = _bitmapData.width - scale9Grid.right;
			_top = scale9Grid.y;
			_bottom = _bitmapData.height - scale9Grid.bottom;
			
			_vertices = createVertices();
			_uvtData = createUVT();
			
			scale9Grid = null;
			scaleX = scaleY = 1;
			draw();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			updateVerticesX();
			draw();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			updateVerticesY();
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginBitmapFill(_bitmapData);
			graphics.drawTriangles(_vertices, Indices, _uvtData);
			graphics.endFill();
		}
		
		private function createVertices():Vector.<Number>
		{
			const x1:Number = _left;
			const x3:Number = _width;
			const x2:Number = _width - _right;
			
			const y1:Number = _top;
			const y3:Number = _height;
			const y2:Number = _height - _bottom;
			
			return new <Number>[
				0, 0,  x1, 0,  x2, 0,  x3, 0,
				0, y1, x1, y1, x2, y1, x3, y1,
				0, y2, x1, y2, x2, y2, x3, y2,
				0, y3, x1, y3, x2, y3, x3, y3
			];
		}
		
		private function updateVerticesX():void
		{
			_vertices[4] = _vertices[12] = _vertices[20] = _vertices[28] = _width - _right;
			_vertices[6] = _vertices[14] = _vertices[22] = _vertices[30] = _width;
		}
		
		private function updateVerticesY():void
		{
			_vertices[17] = _vertices[19] = _vertices[21] = _vertices[23] = _height - _bottom;
			_vertices[25] = _vertices[27] = _vertices[29] = _vertices[31] = _height;
		}
		
		private function createUVT():Vector.<Number>
		{
			const u1:Number = _left	     / _bitmapData.width;
			const u2:Number = 1 - _right / _bitmapData.width;
			
			const v1:Number = _top		 / _bitmapData.height;
			const v2:Number = 1 - _bottom/ _bitmapData.height;
			
			return new <Number>[
				0, 0,  u1, 0,  u2, 0,  1, 0,
				0, v1, u1, v1, u2, v1, 1, v1,
				0, v2, u1, v2, u2, v2, 1, v2,
				0, 1,  u1, 1,  u2, 1,  1, 1
			];
		}
	}
}