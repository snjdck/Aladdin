package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		
		public var themeColor:uint = 0xFFFFFF;
		
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
			isLayoutDirty = true;
			itemList.push(new Separator());
		}
		
		public function addSubMenu(label:String, subMenu:Menu):void
		{
			var item:MenuItem = addItem(label);
			item.subMenu = subMenu;
		}
		
		private function layout():void
		{
			if(isLayoutDirty){
				isLayoutDirty = false;
				DrawTool.RenderMenu(this, itemList);
			}
		}
		
		internal function show(parent:DisplayObjectContainer, offsetX:Number, offsetY:Number=0):void
		{
			layout();
			parent.addChild(this);
			
			if(offsetX + width > stage.stageWidth){
				x = stage.stageWidth - width;
			}else{
				x = offsetX;
			}
			if(offsetY + height > stage.stageHeight){
				y = stage.stageHeight - height;
			}else{
				y = offsetY;
			}
		}
		
		internal function calcWidth():int
		{
			var maxWidth:int = 0;
			for each(var item:IMenuItem in itemList){
				maxWidth = Math.max(maxWidth, item.getWidth());
			}
			return maxWidth;
		}
		
		internal function calcHeight():int
		{
			var nextY:int = 0;
			for each(var item:IMenuItem in itemList){
				nextY += item.getHeight();
			}
			return nextY;
		}
		
		private function removeOldMenu(stage:Stage):void
		{
			for(var i:int=stage.numChildren-1; i>=0; --i){
				var menu:Menu = stage.getChildAt(i) as Menu;
				if(menu != null){
					menu.onClose();
				}
			}
		}
		
		public function display(stage:Stage, stageX:Number, stageY:Number):void
		{
			removeOldMenu(stage);
			show(stage, stageX, stageY);
			clickSignal.add(onClose);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, true);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			if(!contains(evt.target as DisplayObject)){
				onClose();
			}
		}
		
		private function onClose(_:Object=null):void
		{
			clickSignal.del(onClose);
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