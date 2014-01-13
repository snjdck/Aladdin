package stdlib.graphics.path.other
{
	import stdlib.graphics.IPath;
	
	import flash.display.Graphics;
	
	public class Star implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var sides:int;
		public var scale:Number;
		
		public function Star(x:Number, y:Number, radius:Number, sides:int=0, scale:Number=1)
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.sides = Math.max(sides, 5);
			this.scale = scale;
		}
		
		public function draw(target:Graphics):void
		{
			var a:Number = (sides - 2) / sides * 90;		//正多边形每个顶角一半的大小
			var b:Number = 180 - 2 * a;
			
			var p:Number = Math.PI / 180;
			var rx:Number = radius * Math.sin((90 - b) * p) / Math.sin((a + b) * p);	//小半径
			rx = Math.min(rx * scale, radius * Math.sin(a * p));
			
			var step:Number = Math.PI / sides;
			
			var angle:Number = 0;
			var px:Number;
			var py:Number;
			
			target.moveTo(x, y - radius);
			
			for(var i:int=0; i<sides; i++)
			{
				angle += step;
				px = x + rx * Math.sin(angle);
				py = y - rx * Math.cos(angle);
				target.lineTo(px, py);
				//
				angle += step;
				px = x + radius * Math.sin(angle);
				py = y - radius * Math.cos(angle);
				target.lineTo(px, py);
			}
			
			target.moveTo(x, y);
		}
	}
}