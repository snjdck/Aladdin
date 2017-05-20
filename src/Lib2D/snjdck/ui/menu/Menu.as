package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	public class Menu extends Sprite
	{
		public var margin:int = 2;
		public var marginLeft:int = 20;
		public var marginRight:int = 40;
		
		private const itemList:Vector.<IMenuItem> = new Vector.<IMenuItem>();
		private var isLayoutDirty:Boolean;
		
		public const clickSignal:Signal = new Signal(MenuItem);
		
		public function Menu()
		{
		}
		
		public function get numItems():int
		{
			return itemList.length;
		}
		
		public function removeItemAt(index:int):void
		{
			isLayoutDirty = true;
			var item:IMenuItem = itemList.removeAt(index);
			if(item is DisplayObject){
				removeChild(item as DisplayObject);
			}
		}
		
		public function addItem(label:String, handler:Object=null):MenuItem
		{
			isLayoutDirty = true;
			var item:MenuItem = new MenuItem();
			item.x = margin;
			item.menu = this;
			item.name = label;
			item.label = label;
			item.handler = handler;
			addChild(item);
			
			itemList.push(item);
			return item;
		}
		
		public function addSeparator():void
		{
			itemList.push(new Separator());
		}
		
		public function addSubMenu(label:String, subMenu:Menu):void
		{
			var item:MenuItem = addItem(label);
			item.subMenu = subMenu;
		}
		
		public function layout():void
		{
			if(!isLayoutDirty){
				return;
			}
			isLayoutDirty = false;
			
			var maxWidth:Number = marginLeft + calcWidth() + marginRight;
			
			DrawTool.DrawMenuBG(graphics, maxWidth + margin * 2, calcHeight() + margin * 2);
			graphics.beginFill(0xCCCCCC);
			
			var nextY:Number = margin;
			for each(var item:IMenuItem in itemList){
				item.render(this, maxWidth, nextY);
				nextY += item.getHeight();
			}
			
			graphics.endFill();
		}
		
		private function calcWidth():int
		{
			var maxWidth:int = 0;
			for each(var item:IMenuItem in itemList){
				maxWidth = Math.max(maxWidth, item.getWidth());
			}
			return maxWidth;
		}
		
		private function calcHeight():int
		{
			var nextY:int = 0;
			for each(var item:IMenuItem in itemList){
				nextY += item.getHeight();
			}
			return nextY;
		}
		
		public function display(stage:Stage, stageX:Number, stageY:Number):void
		{
			layout();
			x = stageX;
			y = stageY;
			clickSignal.add(__onClose);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, true);
			stage.addChild(this);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			if(!contains(evt.target as DisplayObject)){
				__onClose();
			}
		}
		
		private function __onClose(_:Object=null):void
		{
			clickSignal.del(__onClose);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, true);
			stage.removeChild(this);
		}
		
		public function forEach(handler:Object):void
		{
			for each(var test:IMenuItem in itemList){
				var item:MenuItem = test as MenuItem;
				if(!item || handler(item))
					continue;
				if(item.subMenu != null){
					item.subMenu.forEach(handler);
				}
			}
		}
	}
}