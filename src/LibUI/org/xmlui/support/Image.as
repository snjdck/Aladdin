package org.xmlui.support
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class Image extends Loader
	{
		public function Image(path:String, onLoad:Function=null)
		{
			contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event):void{
				contentLoaderInfo.removeEventListener(evt.type, arguments.callee);
				if(null != onLoad){
					onLoad();
				}
			});
			load(new URLRequest(path));
		}
	}
}