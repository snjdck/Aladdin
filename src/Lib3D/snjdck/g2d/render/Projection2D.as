package snjdck.g2d.render
{
	final public class Projection2D
	{
		private var a:Number = 0;
		private var b:Number = 0;
		private var c:Number = 0;
		private var d:Number = 0;
		
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function Projection2D()
		{
			offset(0, 0);
		}
		
		public function resize(width:int, height:int):void
		{
			a =  2.0 / width;
			b = -2.0 / height;
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			_offsetX = dx;
			_offsetY = dy;
			c = a * dx - 1.0;
			d = b * dy + 1.0;
		}
		
		public function upload(output:Vector.<Number>):void
		{
			output[0] = a;
			output[1] = b;
			output[2] = c;
			output[3] = d;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
	}
}