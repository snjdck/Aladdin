package flash.events
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;

	public class DragEventListener
	{
		private var target:InteractiveObject;
		private var lastEvt:MouseEvent;
		
		private var moveFlag:Boolean;
		public var onBegin:Object;
		public var onMove:Object;
		public var onEnd:Object;
		public var onClick:Object;
		
		public function DragEventListener(target:InteractiveObject)
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			this.target = target;
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
			moveFlag = false;
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			var dx:Number = evt.stageX - lastEvt.stageX;
			var dy:Number = evt.stageY - lastEvt.stageY;
			if(moveFlag){
				$lambda.call(onMove, dx, dy);
			}else if(dx * dx + dy * dy > 64){
				moveFlag = true;
				$lambda.apply(onBegin);
			}
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			lastEvt = null;
			$lambda.apply(onEnd);
			if(!moveFlag){
				$lambda.call(onClick, evt);
			}
			moveFlag = false;
		}
	}
}