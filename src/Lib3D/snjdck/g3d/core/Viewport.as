package snjdck.g3d.core
{
	public class Viewport
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 1;
		public var height:Number = 1;
		
		public function Viewport()
		{
		}
		
		public function adjust(transform:Vector.<Number>, scaleX:Number, scaleY:Number):void
		{
			transform[0] = scaleX * width;
			transform[1] = scaleY * height;
			transform[4] = width  - 1 + 2 * x;
			transform[5] = height - 1 + 2 * y;
		}
		
		public function contains(screenX:Number, screenY:Number):Boolean
		{
			var px:Number = 0.5 * (screenX + 1) - x;
			var py:Number = 0.5 * (screenY + 1) - y;
			return (0 <= px) && (0 <= py) && (px < width) && (py < height);
		}
	}
}