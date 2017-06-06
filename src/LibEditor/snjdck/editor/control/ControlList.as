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
		public const dragSignal:Signal = new Signal(Sprite);
		
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
//			var pt:Point = item.localToGlobal(new Point());
//			var dragItem:Sprite = item.create();
//			dragItem.filters = [new DropShadowFilter()];
//			dragItem.x = pt.x;
//			dragItem.y = pt.y;
			dragSignal.notify(item.create());
		}
	}
}