package stdlib.graphics.path
{
	import flash.display.Graphics;
	
	import stdlib.graphics.IPath;
	
	public class RectPath implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function RectPath(x:Number, y:Number, width:Number, height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function draw(target:Graphics):void
		{
			target.drawRect(x, y, width, height);
		}
	}
}