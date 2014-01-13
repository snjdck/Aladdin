package snjdck.g2d.support
{
	import flash.geom.Matrix;
	
	import matrix33.transformCoords;

	final public class VertexData
	{
		static public const DATA32_PER_VERTEX:int = 9;
		static public const DATA32_PER_QUAD:int = 4 * DATA32_PER_VERTEX;
		
		private var buffer:Vector.<Number>;
		
		public function VertexData()
		{
			buffer = new Vector.<Number>(DATA32_PER_QUAD, true);
		}
		
		public function reset():void
		{
			var x:int, y:int, offset:int;
			
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = 0;
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = buffer[offset++] = buffer[offset++] = buffer[offset++] = 1;
			
			x = 1;
			
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = 0;
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = buffer[offset++] = buffer[offset++] = buffer[offset++] = 1;
			
			y = 1;
			
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = 0;
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = buffer[offset++] = buffer[offset++] = buffer[offset++] = 1;
			
			x = 0;
			
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = 0;
			buffer[offset++] = x;
			buffer[offset++] = y;
			buffer[offset++] = buffer[offset++] = buffer[offset++] = buffer[offset++] = 1;
		}
		
		public function getRawData():Vector.<Number>
		{
			return buffer;
		}
		
		public function transformPosition(matrix:Matrix):void
		{
			var offset:int = 0;
			for(var i:int=0; i<4; i++)
			{
				transformCoords(matrix, buffer[offset], buffer[offset+1], pt);
				buffer[offset] = pt.x;
				buffer[offset+1] = pt.y;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function transformUV(matrix:Matrix):void
		{
			var offset:int = 3;
			for(var i:int=0; i<4; i++)
			{
				transformCoords(matrix, buffer[offset], buffer[offset+1], pt);
				buffer[offset] = pt.x;
				buffer[offset+1] = pt.y;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function set z(value:Number):void
		{
			var offset:int = 2;
			for(var i:int=0; i<4; i++)
			{
				buffer[offset] = value;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function set color(value:uint):void
		{
			var red:Number = 	((value >> 16) & 0xFF) / 0xFF;
			var green:Number =	((value >> 8) & 0xFF) / 0xFF;
			var blue:Number =	(value & 0xFF) / 0xFF;
			
			var offset:int = 5;
			for(var i:int=0; i<4; i++)
			{
				buffer[offset] = red;
				buffer[offset+1] = green;
				buffer[offset+2] = blue;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function set alpha(value:Number):void
		{
			var offset:int = 8;
			for(var i:int=0; i<4; i++)
			{
				buffer[offset] = value;
				offset += DATA32_PER_VERTEX;
			}
		}
	}
}

import flash.geom.Point;

const pt:Point = new Point();