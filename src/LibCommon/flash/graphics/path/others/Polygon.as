package flash.graphics.path.others
{
	import flash.graphics.IPath;
	
	import flash.display.Graphics;
	
	public class Polygon implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var sides:int;
		
		public function Polygon(x:Number, y:Number, radius:Number, sides:int=3)
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.sides = Math.max(sides, 3);
		}
		
		public function draw(target:Graphics):void
		{
			var step:Number = 2 * Math.PI / sides;
			
			var angle:Number = 0;
			
			target.moveTo(x, y - radius);
			
			for(var i:int=0; i<sides; i++)
			{
				angle += step;
				target.lineTo(
					x + radius * Math.sin(angle),
					y - radius * Math.cos(angle)
				);
			}
			
			target.moveTo(x, y);
		}
	}
}