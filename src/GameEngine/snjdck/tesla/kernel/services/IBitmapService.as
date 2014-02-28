package snjdck.tesla.kernel.services
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public interface IBitmapService
	{
		function regBitmap(name:String, path:String, width:int, height:int, scale9Grid:Rectangle=null):void;
		function getBitmap(name:String):DisplayObject;
	}
}