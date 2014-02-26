package flash.graphics.path
{
	import flash.display.Graphics;
	
	import flash.graphics.IPath;
	
	public class CirclePath implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		
		public function CirclePath(x:Number, y:Number, radius:Number)
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
		}
		
		public function draw(target:Graphics):void
		{
			var diameter:Number = radius * 2;
			target.drawRoundRect(x - radius, y - radius, diameter, diameter, diameter, diameter);
		}
	}
}