package snjdck.ui.scale9bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedSuperclassName;

	public class Scale9BitmapFactory
	{
		static public const Instance:Scale9BitmapFactory = new Scale9BitmapFactory();
		
		private const infoDict:Object = {};
		
		public function Scale9BitmapFactory(){}
		
		public function createBitmap(id:String):Sprite
		{
			return new Scale9Bitmap(infoDict[id]);
		}
		
		public function load(url:String):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, __onLoad);
			ldr.load(new URLRequest(url));
		}
		
		private function __onLoad(evt:Event):void
		{
			var domain:ApplicationDomain = (evt.target as LoaderInfo).applicationDomain;
			for each(var name:String in domain.getQualifiedDefinitionNames()){
				var clazz:Class = domain.getDefinition(name) as Class;
				if(getQualifiedSuperclassName(clazz) != "TestScaleBitmap"){
					continue;
				}
				var item:Sprite = new clazz();
				var bmd:BitmapData = (item.getChildAt(0) as Bitmap).bitmapData;
				infoDict[name] = new Scale9BitmapInfo(bmd, item.scale9Grid);
			}
		}
	}
}