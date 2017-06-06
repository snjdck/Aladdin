package flash.events
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;

	public class DragStartEventListener
	{
		private var target:InteractiveObject;
		private var handler:Object;
		private var lastEvt:MouseEvent;
		
		public function DragStartEventListener(target:InteractiveObject, handler:Object)
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			this.target = target;
			this.handler = handler;
		}
		
		private function get stage():Stage
		{
			return target.stage;
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			lastEvt = evt;
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			var dx:Number = evt.stageX - lastEvt.stageX;
			var dy:Number = evt.stageY - lastEvt.stageY;
			if(dx * dx + dy * dy <= 64){
				return;
			}
			__onMouseUp(evt);
			$lambda.apply(handler);
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			lastEvt = null;
		}
	}
}