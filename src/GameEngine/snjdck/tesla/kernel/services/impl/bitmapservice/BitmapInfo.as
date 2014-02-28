package snjdck.tesla.kernel.services.impl.bitmapservice
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.http.loadMedia;
	
	import flash.display.IDisplayObject;

	internal class BitmapInfo implements IDisplayObject
	{
		public var name:String;
		public var path:String
		
		public var width:int
		public var height:int;
		
		public var scale9Grid:Rectangle;
		
		private var bitmap:BitmapShape;
		
		public function BitmapInfo()
		{
		}
		
		public function getDisplayObject():DisplayObject
		{
			if(null == bitmap){
				bitmap = new BitmapShape(width, height);
				bitmap.scale9Grid = scale9Grid;
				loadMedia(path, [__onLoad, bitmap.bitmapData]);
			}
			return bitmap;
		}
		
		private function __onLoad(ok:Boolean, data:*, target:BitmapData):void
		{
			if(ok){
				var image:Bitmap = data;
				target.copyPixels(image.bitmapData, target.rect, new Point());
			}else{
				throw data;
			}
		}
	}
}