package snjdck.display.d2
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import stdlib.object_map;
	import flash.bitmap.splitImage;
	import flash.display.AniBitmap;

	public class AniFactory extends EventDispatcher
	{
		private var configPath:String;
		private var ldr:EventDispatcher;
		private var aniDict:Object = {};
		private var configData:XML;
		
		public function AniFactory()
		{
//			ldr = new AssetLoader();
//			ldr.addEventListener(Event.COMPLETE, __onLoad);
		}
		/*
		private function __onLoad(evt:Event):void
		{
			var file:XML;
			if(configPath){
				configData = ldr.getData(configPath);
				configPath = null;
				for each(file in configData.file){
					ldr.addTask(file.@name);
				}
				ldr.load();
			}else{
				for each(file in configData.file){
					var bitmapData:BitmapData = ldr.getData(file.@name).bitmapData;
					var bmdList:Array = bmd_split(bitmapData, file.@column, file.@row);
					bitmapData.dispose();
					for each(var ani:XML in file.animation){
						var aniBitmap:AniBitmap = new AniBitmap(calcFrameList(ani.@frameList, bmdList));
						aniBitmap.repeatCount = ani.@repeat;
						aniDict[ani.@name.toString()] = aniBitmap;
					}
				}
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		*/
		private function calcFrameList(frameIndex:String, bmdList:Array):Array
		{
			////framelist加上空白,负数,浮点,范围(0,2-9,12)支持
			return object_map(frameIndex.split(","), bmdList, []);
		}
		/*
		public function load(path:String):void
		{
			configPath = path;
			ldr.addTask(path);
			ldr.load();
		}
		*/
		public function getAni(name:String):AniBitmap
		{
			return aniDict[name];
		}
	}
}