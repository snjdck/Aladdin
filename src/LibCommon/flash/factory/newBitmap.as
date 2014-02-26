package flash.factory
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;

	public function newBitmap(parent:DisplayObjectContainer=null, bitmapData:BitmapData=null):Bitmap
	{
		var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
		if(null != parent){
			parent.addChild(bitmap);
		}
		return bitmap;
	}
}