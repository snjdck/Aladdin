package filesystem
{
	import flash.events.Event;
	
	import lambda.execFunc;

	public function file_save(data:*, handler:Function=null, defaultFileName:String=null):void
	{
		fr.addEventListener(Event.CANCEL, __onResult);
		fr.addEventListener(Event.COMPLETE, __onResult);
		
		fr.save(data, defaultFileName);
		
		function __onResult(evt:Event):void
		{
			fr.removeEventListener(Event.CANCEL, __onResult);
			fr.removeEventListener(Event.COMPLETE, __onResult);
			lambda.execFunc(handler, evt.type == Event.COMPLETE);
		}
	}
}

import flash.net.FileReference;

const fr:FileReference = new FileReference();