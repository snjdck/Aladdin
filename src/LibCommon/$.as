package{
	public const $:Global = new Global();
}

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

class Global
{
	public var root:Sprite;
	
	public function Global()
	{
	}
	
	private function get stage():Stage
	{
		return root.stage;
	}
	
	public function nextFrameDo(handler:Object):void
	{
		root.addEventListener(Event.ENTER_FRAME, function(evt:Event):void{
			root.removeEventListener(evt.type, arguments.callee);
			$lambda.apply(handler);
		});
	}
}