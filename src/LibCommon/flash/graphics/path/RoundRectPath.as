package flash.graphics.path
{
	import flash.display.Graphics;
	
	import flash.graphics.IPath;
	
	public class RoundRectPath implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var ellipseWidth:Number;
		public var ellipseHeight:Number;
		
		public function RoundRectPath(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number=NaN)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.ellipseWidth = ellipseWidth;
			this.ellipseHeight = ellipseHeight;
		}
		
		public function draw(target:Graphics):void
		{
			target.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
		}
	}
}