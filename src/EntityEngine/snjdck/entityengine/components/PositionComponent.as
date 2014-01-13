package snjdck.entityengine.components
{
	import flash.geom.Point;
	
	import snjdck.entityengine.IComponent;

	public class PositionComponent implements IComponent
	{
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		public function PositionComponent(x:Number=0, y:Number=0, rotation:Number=0)
		{
			this.x = x;
			this.y = y;
			this.rotation = rotation;
		}
		
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		public function distance(another:PositionComponent):Number
		{
			var dx:Number = this.x - another.x;
			var dy:Number = this.y - another.y;
			return Math.sqrt(dx*dx+dy*dy);
		}
	}
}