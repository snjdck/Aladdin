package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Menu extends BaseMenu
	{
		public var margin:int = 2;
		public var marginLeft:int = 20;
		public var marginRight:int = 40;
		
		private const itemList:Vector.<IMenuItem> = new Vector.<IMenuItem>();
		private var isLayoutDirty:Boolean;
		
		public var themeColor:uint = 0xFFFFFF;
		
		public function Menu(useCapture:Boolean=false)
		{
		}
		
		public function get numItems():int
		{
			return itemList.length;
		}
		
		public function getItemAt(index:int):MenuItem
		{
			return itemList[index] as MenuItem;
		}
		
		public function removeItemAt(index:int):void
		{
			invalidate();
			var item:IMenuItem = itemList.removeAt(index);
			if(item is DisplayObject){
				removeChild(item as DisplayObject);
			}
		}
		
		public function addItem(label:String, handler:Object=null):MenuItem
		{
			invalidate();
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
			invalidate();
			itemList.push(new Separator());
		}
		
		public function addSubMenu(label:String, subMenu:Menu):void
		{
			var item:MenuItem = addItem(label);
			item.subMenu = subMenu;
		}
		
		override protected function onDraw():void
		{
			if(itemList.length > 0){
				DrawTool.RenderMenu(this, itemList);
			}
		}
		
		internal function show(parent:DisplayObjectContainer, offsetX:Number, offsetY:Number=0):void
		{
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
		
		public function display(parent:DisplayObjectContainer, stageX:Number, stageY:Number):void
		{
			removeOtherMenus(parent);
			show(parent, stageX, stageY);
			listenCloseEvents();
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