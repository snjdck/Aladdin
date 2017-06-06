package snjdck.editor.menu
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	internal class ContextMenuBase
	{
		private const menu:ContextMenu = new ContextMenu();
		
		public function ContextMenuBase(){}
		
		public function attach(target:InteractiveObject):void
		{
			target.contextMenu = menu;
		}
		
		protected function addItem(label:String, handler:Function):ContextMenuItem
		{
			var item:ContextMenuItem = new ContextMenuItem(label);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
			menu.customItems.push(item);
			return item;
		}
		
		protected function getTarget(evt:ContextMenuEvent):DisplayObject
		{
			var target:DisplayObject = evt.contextMenuOwner;
			if(target is ImageControl){
				target = (target as ImageControl).getTarget();
			}
			return target;
		}
	}
}