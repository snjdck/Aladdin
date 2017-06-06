package snjdck.editor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DragMgr
	{
		static public const Instance:DragMgr = new DragMgr();
		
		private var dragItem:Sprite;
		private var handler:Object;
		
		private var mouseEnabled:Boolean;
		private var mouseChildren:Boolean;
		
		public function DragMgr()
		{
		}
		
		public function doDrag(dragItem:Sprite, handler:Object):void
		{
			$.stage.addChild(dragItem);
			$.stage.addEventListener(MouseEvent.MOUSE_UP, __onStopDrag);
			dragItem.startDrag();
			this.dragItem = dragItem;
			this.handler = handler;
			mouseEnabled = dragItem.mouseEnabled;
			mouseChildren = dragItem.mouseChildren;
			dragItem.mouseEnabled = false;
			dragItem.mouseChildren = false;
		}
		
		private function __onStopDrag(evt:MouseEvent):void
		{
			dragItem.stopDrag();
			$.stage.removeEventListener(MouseEvent.MOUSE_UP, __onStopDrag);
			$.stage.removeChild(dragItem);
			
			$lambda.apply(handler, [dragItem, evt]);
			
			dragItem.mouseEnabled = mouseEnabled;
			dragItem.mouseChildren = mouseChildren;
			
			dragItem = null;
			handler = null;
		}
	}
}