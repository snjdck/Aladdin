package http
{
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	internal function configHttpCallback(target:IEventDispatcher, handler:Function, progress:Function):void
	{
		target.addEventListener(Event.COMPLETE,						__onResult);
		target.addEventListener(IOErrorEvent.IO_ERROR,				__onResult);
		target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__onResult);
		if(null != progress){
			target.addEventListener(ProgressEvent.PROGRESS,			__onResult);
		}
		
		function __onResult(evt:Event):void
		{
			if(evt is ProgressEvent){
				progress(evt["bytesLoaded"], evt["bytesTotal"]);
				return;
			}
			
			target.removeEventListener(Event.COMPLETE,						__onResult);
			target.removeEventListener(IOErrorEvent.IO_ERROR,				__onResult);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__onResult);
			target.removeEventListener(ProgressEvent.PROGRESS,				__onResult);
			
			var ok:Boolean;
			var data:* = null;
			
			if(evt is ErrorEvent){//加载失败
				ok = false;
				data = evt["text"];
			}else{//加载成功
				ok = true;
				if(evt.target is LoaderInfo){
					data = evt.target.content;
					evt.target.loader.unload();
				}else if(evt.target is URLStream){
					data = new ByteArray();
					evt.target.readBytes(data);
				}
			}
			
			handler(ok, data);
		}
	}
}