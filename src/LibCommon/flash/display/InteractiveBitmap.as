package flash.display
{
	import flash.factory.newBitmap;
	
	public class InteractiveBitmap extends Sprite
	{
		protected var bitmap:Bitmap;
		
		public function InteractiveBitmap(bitmapData:BitmapData=null)
		{
			bitmap = newBitmap(this, bitmapData);
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