package snjdck.geom
{
	public class Parabola
	{
		static public function Create(headX:Number, headY:Number, ptX:Number, ptY:Number):Parabola
		{
			var a:Number = (ptY - headY) / ((ptX - headX) * (ptX - headX));
			return new Parabola(headX, headY, a);
		}
		
		private var h:Number;
		private var k:Number;
		private var a:Number;
		
		public function Parabola(h:Number, k:Number, a:Number)
		{
			this.h = h;
			this.k = k;
			this.a = a;
		}
		
		private function get b():Number
		{
			return -2 * a * h;
		}
		
		private function get c():Number
		{
			return a * h * h + k;
		}
		
		public function getX(y:Number):Array
		{
			var t:Number = Math.sqrt((y - k) / a);
			return [h-t, h+t];
		}
		
		public function getY(x:Number):Number
		{
			return a * (x - h) * (x - h) + k;
		}
	}
}