package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import snjdck.flascc.decryptBytes;
	
	public class Shell extends Sprite
	{
		private var ldr:Loader;
		
		public function Shell(ba:ByteArray)
		{
			decryptBytes(ba);
			
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, __onLoad);
			ldr.loadBytes(ba);
			
			ba.clear();
		}
		
		private function __onLoad(evt:Event):void
		{
			var content:DisplayObject = ldr.content;
			
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, __onLoad);
			ldr.unload();
			ldr = null;
			
			stage.addChild(content);
			stage.removeChild(this);
		}
	}
}