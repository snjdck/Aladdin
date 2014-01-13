package snjdck.tesla.kernel.services
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import snjdck.mvc.core.IService;
	
	public interface IBitmapService extends IService
	{
		function regBitmap(name:String, path:String, width:int, height:int, scale9Grid:Rectangle=null):void;
		function getBitmap(name:String):DisplayObject;
	}
}