package stdlib.graphics.brush
{
	import flash.display.Graphics;
	import stdlib.graphics.IBrush;

	public class SolidBrush implements IBrush
	{
		public var color:uint;
		public var alpha:Number;
		
		public function SolidBrush(color:uint=0, alpha:Number=1.0)
		{
			this.color = color;
			this.alpha = alpha;
		}

		public function beginFill(target:Graphics):void
		{
			target.beginFill(color, alpha);
		}
	}
}