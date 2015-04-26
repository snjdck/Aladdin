package snjdck.gpu
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.signals.Signal;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;

	final public class Input implements ITicker
	{
		public var isMouseDown:Boolean;
		public var isMouseMove:Boolean;
		
		public const mouseLocation:Vector3D = new Vector3D();
		
		public const mouseMoveSignal:Signal = new Signal();
		public const mouseDownSignal:Signal = new Signal();
		public const mouseUpSignal:Signal = new Signal();
		public const clickSignal:Signal = new Signal();
		
		public function Input(stage:Stage)
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,	__onStageEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,		__onStageEvent);
//			stage.addEventListener(MouseEvent.CLICK,		__onStageEvent);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 	__onMouseMove);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			isMouseMove = true;
			mouseLocation.setTo(evt.stageX, evt.stageY, 0);
		}
		
		public function onTick(timeElapsed:int):void
		{
			if(!isMouseMove){
				return;
			}
			isMouseMove = false;
			mouseMoveSignal.notify();
		}
		
		private function __onStageEvent(evt:MouseEvent):void
		{
			mouseLocation.setTo(evt.stageX, evt.stageY, 0);
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					isMouseDown = true;
					mouseDownSignal.notify();
					break;
				case MouseEvent.MOUSE_UP:
					isMouseDown = false;
					mouseUpSignal.notify();
					break;
				case MouseEvent.CLICK:
					clickSignal.notify();
					break;
			}
			App3D.app.view3d.notifyEvent(evt.type);
		}
	}
}