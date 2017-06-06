package snjdck.editor.control
{
	import flash.display.Sprite;
	import flash.events.DragStartEventListener;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	public class ControlList extends Sprite
	{
		public const dragSignal:Signal = new Signal(XML);
		public const clickSignal:Signal = new Signal(XML);
		
		public function ControlList()
		{
			opaqueBackground = 0xFF00;
		}
		
		public function loadXML(xml:XML):void
		{
			for each(var itemXML:XML in xml.children()){
				var item:ControlItem = new ControlItem(itemXML);
				item.addEventListener(MouseEvent.CLICK, __onClick);
				new DragStartEventListener(item, [__onDragStart, item]);
				addChild(item);
				item.y = numChildren * 30;
			}
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			var item:ControlItem = evt.currentTarget as ControlItem;
			clickSignal.notify(item.config);
		}
		
		private function __onDragStart(item:ControlItem):void
		{
			dragSignal.notify(item.config);
		}
	}
}