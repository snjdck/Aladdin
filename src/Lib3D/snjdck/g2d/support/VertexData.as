package snjdck.g2d.support
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import matrix33.transformCoords;

	final public class VertexData
	{
		static public const OFFSET_XYZ:int = 0;
		static public const OFFSET_UV:int = 2;
		static public const OFFSET_COLOR:int = 4;
		
		static public const DATA32_PER_VERTEX:int = 5;
		static public const DATA32_PER_QUAD:int = 4 * DATA32_PER_VERTEX;
		
		private var buffer:Vector.<Number>;
		
		public function VertexData()
		{
			buffer = new Vector.<Number>(DATA32_PER_QUAD, true);
		}
		
		public function reset(x:Number, y:Number, width:Number, height:Number):void
		{
			var ratioX:int, ratioY:int, offset:int;
			
			buffer[offset++] = x + ratioX * width;
			buffer[offset++] = y + ratioY * height;
			buffer[offset++] = ratioX;
			buffer[offset++] = ratioY;
			buffer[offset++] = 1;
			
			ratioX = 1;
			
			buffer[offset++] = x + ratioX * width;
			buffer[offset++] = y + ratioY * height;
			buffer[offset++] = ratioX;
			buffer[offset++] = ratioY;
			buffer[offset++] = 1;
			
			ratioY = 1;
			
			buffer[offset++] = x + ratioX * width;
			buffer[offset++] = y + ratioY * height;
			buffer[offset++] = ratioX;
			buffer[offset++] = ratioY;
			buffer[offset++] = 1;
			
			ratioX = 0;
			
			buffer[offset++] = x + ratioX * width;
			buffer[offset++] = y + ratioY * height;
			buffer[offset++] = ratioX;
			buffer[offset++] = ratioY;
			buffer[offset++] = 1;
		}
		
		public function getRawData():Vector.<Number>
		{
			return buffer;
		}
		
		public function transformPosition(matrix:Matrix):void
		{
			var offset:int = OFFSET_XYZ;
			for(var i:int=0; i<4; i++)
			{
				transformCoords(matrix, buffer[offset], buffer[offset+1], tempPt);
				buffer[offset] = tempPt.x;
				buffer[offset+1] = tempPt.y;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function transformUV(matrix:Matrix):void
		{
			var offset:int = OFFSET_UV;
			for(var i:int=0; i<4; i++)
			{
				transformCoords(matrix, buffer[offset], buffer[offset+1], tempPt);
				buffer[offset] = tempPt.x;
				buffer[offset+1] = tempPt.y;
				offset += DATA32_PER_VERTEX;
			}
		}
		/*
		public function set color(value:uint):void
		{
			var red:Number = 	((value >> 16) & 0xFF) / 0xFF;
			var green:Number =	((value >> 8) & 0xFF) / 0xFF;
			var blue:Number =	(value & 0xFF) / 0xFF;
			
			var offset:int = OFFSET_COLOR;
			for(var i:int=0; i<4; i++)
			{
				buffer[offset] = red;
				buffer[offset+1] = green;
				buffer[offset+2] = blue;
				offset += DATA32_PER_VERTEX;
			}
		}
		//*/
		public function set alpha(value:Number):void
		{
			var offset:int = OFFSET_COLOR;
			for(var i:int=0; i<4; i++)
			{
				buffer[offset] = value;
				offset += DATA32_PER_VERTEX;
			}
		}
		
		public function getBounds(transform:Matrix, result:Rectangle):void
		{
			var minX:Number = Number.MAX_VALUE, maxX:Number = Number.MIN_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = Number.MIN_VALUE;
			
			var offset:int = OFFSET_XYZ;
			for(var i:int=0; i<4; i++)
			{
				transformCoords(transform, buffer[offset], buffer[offset+1], tempPt);
				offset += DATA32_PER_VERTEX;
				
				if(tempPt.x < minX){ minX = tempPt.x; }
				if(tempPt.y < minY){ minY = tempPt.y; }
				if(tempPt.x > maxX){ maxX = tempPt.x; }
				if(tempPt.y > maxY){ maxY = tempPt.y; }
			}
			
			result.setTo(minX, minY, maxX-minX, maxY-minY);
		}
		
		static private const tempPt:Point = new Point();
	}
}