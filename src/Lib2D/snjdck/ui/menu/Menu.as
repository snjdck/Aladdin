package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	import lambda.apply;
	
	public class Menu extends Sprite
	{
		private const itemList:Array = [];
		private var isLayoutDirty:Boolean;
		
		public const clickSignal:Signal = new Signal(MenuItem);
		private var bg:Shape;
		
		public function Menu()
		{
			bg = new Shape();
			addChild(bg);
		}
		
		public function addItem(label:String, handler:Object=null):MenuItem
		{
			isLayoutDirty = true;
			var item:MenuItem = new MenuItem();
			item.menu = this;
			item.name = label;
			item.label = label;
			item.handler = handler;
			addChild(item);
			
			item.addEventListener(MouseEvent.CLICK, __onClick);
			itemList.push(item);
			return item;
		}
		
		public function addSeparator():void
		{
			itemList.push(null);
		}
		
		public function addSubMenu(label:String, subMenu:Menu):void
		{
			var item:MenuItem = addItem(label);
			item.subMenu = subMenu;
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			evt.stopPropagation();
			var item:MenuItem = evt.currentTarget as MenuItem;
			if(item.subMenu){
				return;
			}
			var testItem:MenuItem = item;
			lambda.apply(testItem.handler);
			while(testItem != null){
				testItem.menu.clickSignal.notify(item);
				testItem = testItem.menu.parent as MenuItem;
			}
		}
		
		private function redraw(w:Number, h:Number):void
		{
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x999999);
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function layout():void
		{
			if(!isLayoutDirty){
				return;
			}
			isLayoutDirty = false;
			
			var item:MenuItem;
			var maxWidth:Number = 0;
			var nextY:Number = 0;
			for each(item in itemList){
				if (!item) continue;
				maxWidth = Math.max(maxWidth, item.width);
			}
			
			bg.graphics.clear();
//			bg.graphics.lineStyle(0);
			bg.graphics.beginFill(0xCCCCCC);
			
			for each(item in itemList){
				if(item != null){
					item.width = maxWidth;
					item.y = nextY;
					nextY += item.height;
				}else{
//					bg.graphics.moveTo(MenuItem.marginLeft, nextY);
//					bg.graphics.lineTo(maxWidth - 4, nextY);
					bg.graphics.drawRect(MenuItem.marginLeft, nextY, maxWidth - MenuItem.marginLeft - 4, 1);
					nextY += 1;
				}
			}
			
			redraw(maxWidth, nextY);
		}
		/*
		public function addShadow():void
		{
			var filter:DropShadowFilter = new DropShadowFilter();
			filter.blurX = filter.blurY = 5;
			filter.distance = 3;
			filter.color = 0x333333;
			filters = [filter];
		}
		//*/
		public function display(stage:Stage, stageX:Number, stageY:Number):void
		{
			layout();
			x = stageX;
			y = stageY;
			clickSignal.add(__onClose);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, true);
			stage.addEventListener(Event.DEACTIVATE, __onClose);
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
			stage.removeEventListener(Event.DEACTIVATE, __onClose);
			stage.removeChild(this);
		}
		
		public function forEach(handler:Object):void
		{
			for each(var item:MenuItem in itemList){
				var skipFlag:Boolean = handler(item);
				if(skipFlag){
					continue;
				}
				if(item.subMenu != null){
					item.subMenu.forEach(handler);
				}
			}
		}
	}
}