package stdlib.graphics.path.other
{
	import stdlib.graphics.IPath;
	
	import flash.display.Graphics;
	
	public class Sector implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var angle:int;			//扇形的弧的度数,角度为单位
		
		public function Sector(x:Number, y:Number, radius:Number, angle:int)
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.angle = angle % 720;
		}
		
		public function draw(target:Graphics):void
		{
			var step:Number = Math.PI / 180;
			
			var t:Number = 0;
			
			target.moveTo(x, y);
			target.lineTo(x, y - radius);
			
			for(var i:int=0; i<angle; i++)
			{
				t += step;
				target.lineTo(
					x + radius * Math.sin(t),
					y - radius * Math.cos(t)
				);
			}
			
			target.lineTo(x, y);
		}
	}
}