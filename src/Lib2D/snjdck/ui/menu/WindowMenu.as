package snjdck.ui.menu
{
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	import snjdck.ui.DrawObject;

	public class WindowMenu extends DrawObject
	{
		private const itemList:Vector.<WindowMenuItem> = new Vector.<WindowMenuItem>();
		
		internal var showMenuFlag:Boolean;
		internal var focusItem:WindowMenuItem;
		
		public const clickSignal:Signal = new Signal(MenuItem);
		
		public function WindowMenu()
		{
			addEventListener(MouseEvent.ROLL_OUT, __onMouseOut);
		}
		
		private function __onMouseOut(evt:MouseEvent):void
		{
			if(!showMenuFlag && focusItem){
				focusItem.onFocusOut();
				focusItem = null;
			}
		}
		
		override protected function onDraw():void
		{
			var nextX:Number = 0;
			for each(var item:WindowMenuItem in itemList){
				item.x = nextX;
				nextX += item.width;
			}
		}
		
		public function addItem(label:String, menu:Menu):void
		{
			var item:WindowMenuItem = new WindowMenuItem(label, menu);
			item.name = label;
			item.windowMenu = this;
			addChild(item);
			itemList.push(item);
			menu.clickSignal.add(clickSignal.notify);
			
			invalidate();
		}
	}
}