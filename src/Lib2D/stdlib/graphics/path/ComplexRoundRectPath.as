package stdlib.graphics.path
{
	import flash.display.Graphics;
	
	import stdlib.graphics.IPath;
	
	public class ComplexRoundRectPath implements IPath
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var topLeftRadius:Number;
		public var topRightRadius:Number;
		public var bottomLeftRadius:Number;
		public var bottomRightRadius:Number;
		
		public function ComplexRoundRectPath(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.topLeftRadius = topLeftRadius;
			this.topRightRadius = topRightRadius;
			this.bottomLeftRadius = bottomLeftRadius;
			this.bottomRightRadius = bottomRightRadius;
		}
		
		public function draw(target:Graphics):void
		{
			target.drawRoundRectComplex(x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
		}
	}
}