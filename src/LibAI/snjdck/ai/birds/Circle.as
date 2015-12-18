package snjdck.ai.birds
{
	import flash.display.Sprite;
	import flash.geom.Vec2D;

	public class Circle extends Sprite
	{
		private var _radius:Number;
		private var _color:uint;
		
		public function Circle(radius:Number, color:uint = 0x000000)
		{
			_radius = radius;
			_color = color;
			graphics.lineStyle(0, _color);
			graphics.drawCircle(0, 0, _radius);
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function get position():Vec2D
		{
			return new Vec2D(x, y);
		}
	}
}