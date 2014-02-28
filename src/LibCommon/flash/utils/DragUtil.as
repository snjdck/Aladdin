package flash.utils
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	final public class DragUtil
	{
		static public function SetDraggable(target:Sprite, flag:Boolean=true):void
		{
			if(flag){
				target.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			}else{
				target.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			}
		}
		
		static private function __onMouseDown(evt:MouseEvent):void
		{
			var target:Sprite = evt.currentTarget as Sprite;
			if(evt.target == target){
				target.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
				target.startDrag();
			}
		}
		
		static private function __onMouseUp(evt:MouseEvent):void
		{
			var target:Sprite = evt.currentTarget as Sprite;
			target.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			target.stopDrag();
		}
	}
}