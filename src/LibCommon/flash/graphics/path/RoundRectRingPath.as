package flash.graphics.path
{
	import flash.display.Graphics;
	
	import flash.graphics.IPath;
	
	public class RoundRectRingPath implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var ellipseSize:Number;
		public var gap:Number;
		
		public function RoundRectRingPath(x:Number, y:Number, width:Number, height:Number, ellipseSize:Number, gap:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.ellipseSize = ellipseSize;
			this.gap = gap;
		}
		
		public function draw(target:Graphics):void
		{
			target.drawRoundRect(x, y, width, height, ellipseSize);
			target.drawRoundRect(x + gap, y + gap, width - gap * 2, height - gap * 2, ellipseSize);
		}
	}
}