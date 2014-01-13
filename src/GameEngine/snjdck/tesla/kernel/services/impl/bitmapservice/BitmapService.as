package snjdck.tesla.kernel.services.impl.bitmapservice
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import snjdck.tesla.kernel.services.IBitmapService;
	import snjdck.tesla.kernel.services.support.Service;
	
	public class BitmapService extends Service implements IBitmapService
	{
		private var regInfoDict:Object;
		
		public function BitmapService()
		{
			regInfoDict = {};
		}
		
		public function regBitmap(name:String, path:String, width:int, height:int, scale9Grid:Rectangle=null):void
		{
			var info:BitmapInfo = new BitmapInfo();
			
			info.name = name;
			info.path = path;
			info.width = width;
			info.height = height;
			info.scale9Grid = scale9Grid;
			
			regInfoDict[name] = info;
		}
		
		public function getBitmap(name:String):DisplayObject
		{
			var info:BitmapInfo = regInfoDict[name];
			if(null == info){
				return null;
			}
			return info.getDisplayObject();
		}
	}
}