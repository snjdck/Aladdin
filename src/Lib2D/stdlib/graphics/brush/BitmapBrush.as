package stdlib.graphics.brush
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import stdlib.graphics.IBrush;

	public class BitmapBrush implements IBrush
	{
		public var bitmap:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		public function BitmapBrush(bitmap:BitmapData, matrix:Matrix=null)
		{
			this.bitmap = bitmap;
			this.matrix = matrix;
		}

		public function beginFill(target:Graphics):void
		{
			target.beginBitmapFill(bitmap, matrix, true, false);
		}
	}
}