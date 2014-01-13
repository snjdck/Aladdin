package snjdck.display.d2
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import stdlib.factory.newBitmap;
	
	public class InteractiveBitmap extends Sprite
	{
		protected var bitmap:Bitmap;
		
		public function InteractiveBitmap(bitmapData:BitmapData=null)
		{
			bitmap = stdlib.factory.newBitmap(this, bitmapData);
		}
		
		public function get bitmapData():BitmapData
		{
			return bitmap.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			bitmap.bitmapData = value;
		}
	}
}