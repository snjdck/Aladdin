package snjdck.gpu
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

	internal class StageEventProxy
	{
		static private const eventList:Array = [
			MouseEvent.RIGHT_CLICK,
			MouseEvent.RIGHT_MOUSE_DOWN,
			MouseEvent.RIGHT_MOUSE_UP,
			MouseEvent.CLICK,
			MouseEvent.MOUSE_DOWN,
			MouseEvent.MOUSE_UP
		];
		
		public var isMouseMoved:Boolean;
		
		public function StageEventProxy()
		{
			isMouseMoved = true;
		}
		
		public function listenStageEvent(stage:Stage, handler:Function):void
		{
			for each(var evtName:String in eventList)
				stage.addEventListener(evtName, handler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			isMouseMoved = true;
		}
	}
}