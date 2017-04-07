package snjdck.ui.scale9bitmap
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.d3.createMeshIndices;

	internal class Scale9BitmapInfo
	{
		static private const indices:Vector.<int> = new Vector.<int>();
		createMeshIndices(4, 4, indices);
		
		private var bitmapData:BitmapData;
		private var uvtData:Vector.<Number>;
		
		public var width:int;
		public var height:int;
		
		private var left:int;
		private var right:int;
		private var top:int;
		private var bottom:int;
		
		public function Scale9BitmapInfo(bitmapData:BitmapData, scale9Grid:Rectangle)
		{
			this.bitmapData = bitmapData;
			
			width = bitmapData.width;
			height = bitmapData.height;
			
			left = scale9Grid.x;
			top = scale9Grid.y;
			right = width - scale9Grid.right;
			bottom = height - scale9Grid.bottom;
			
			uvtData = createUVT();
		}
		
		private function createUVT():Vector.<Number>
		{
			const u1:Number = left	    / width;
			const u2:Number = 1 - right / width;
			
			const v1:Number = top		/ height;
			const v2:Number = 1 - bottom/ height;
			
			return new <Number>[
				0, 0,  u1, 0,  u2, 0,  1, 0,
				0, v1, u1, v1, u2, v1, 1, v1,
				0, v2, u1, v2, u2, v2, 1, v2,
				0, 1,  u1, 1,  u2, 1,  1, 1
			];
		}
		
		public function draw(g:Graphics, vertices:Vector.<Number>):void
		{
			g.beginBitmapFill(bitmapData);
			g.drawTriangles(vertices, indices, uvtData);
			g.endFill();
		}
		
		public function createVertices():Vector.<Number>
		{
			const x1:Number = left;
			const x3:Number = width;
			const x2:Number = width - right;
			
			const y1:Number = top;
			const y3:Number = height;
			const y2:Number = height - bottom;
			
			return new <Number>[
				0, 0,  x1, 0,  x2, 0,  x3, 0,
				0, y1, x1, y1, x2, y1, x3, y1,
				0, y2, x1, y2, x2, y2, x3, y2,
				0, y3, x1, y3, x2, y3, x3, y3
			];
		}
		
		public function updateVerticesX(vertices:Vector.<Number>, width:Number):void
		{
			vertices[4] = vertices[12] = vertices[20] = vertices[28] = width - right;
			vertices[6] = vertices[14] = vertices[22] = vertices[30] = width;
		}
		
		public function updateVerticesY(vertices:Vector.<Number>, height:Number):void
		{
			vertices[17] = vertices[19] = vertices[21] = vertices[23] = height - bottom;
			vertices[25] = vertices[27] = vertices[29] = vertices[31] = height;
		}
	}
}