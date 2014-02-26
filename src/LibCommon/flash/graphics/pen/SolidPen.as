package flash.graphics.pen
{
	import flash.display.Graphics;
	
	import flash.graphics.IPen;

	public class SolidPen implements IPen
	{
		public var thickness:Number;
		public var color:uint;
		public var alpha:Number;
		
		public function SolidPen(thickness:Number=0, color:uint=0, alpha:Number=1.0)
		{
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
		}

		public function apply(target:Graphics):void
		{
			target.lineStyle(thickness, color, alpha, true);
		}
	}
}