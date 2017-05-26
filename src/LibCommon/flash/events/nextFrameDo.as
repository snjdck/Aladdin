package flash.events
{
	import lambda.apply;

	public function nextFrameDo(handler:Object):void
	{
		source.addEventListener(Event.ENTER_FRAME, function(evt:Event):void{
			source.removeEventListener(evt.type, arguments.callee);
			lambda.apply(handler);
		});
	}
}

import flash.display.Shape;
const source:Shape = new Shape();