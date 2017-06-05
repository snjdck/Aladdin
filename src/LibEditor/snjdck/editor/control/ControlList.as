package snjdck.editor.control
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.signals.Signal;
	
	public class ControlList extends Sprite
	{
		private var dragItem:Sprite;
		
		public const dropSignal:Signal = new Signal(Sprite);
		
		public function ControlList()
		{
			opaqueBackground = 0xFF00;
		}
		
		public function loadXML(xml:XML):void
		{
			for each(var itemXML:XML in xml.children()){
				var item:ControlItem = new ControlItem(itemXML);
				item.addEventListener(MouseEvent.MOUSE_DOWN, __onDrag);
				addChild(item);
				item.y = numChildren * 30;
			}
		}
		
		private function __onDrag(evt:MouseEvent):void
		{
			var item:ControlItem = evt.currentTarget as ControlItem;
			var pt:Point = item.localToGlobal(new Point());
			dragItem = item.create();
			dragItem.filters = [new DropShadowFilter()];
			dragItem.x = pt.x;
			dragItem.y = pt.y;
			dragItem.mouseEnabled = false;
			stage.addChild(dragItem);
			dragItem.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, __onStopDrag);
		}
		
		private function __onStopDrag(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onStopDrag);
			dragItem.stopDrag();
			
			if(contains(evt.target as DisplayObject)){
				stage.removeChild(dragItem);
			}else{
				dragItem.mouseEnabled = true;
				dragItem.filters = [];
				dropSignal.notify(dragItem);
			}
			
			dragItem = null;
		}
	}
}