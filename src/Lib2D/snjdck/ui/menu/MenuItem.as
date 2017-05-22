package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import lambda.apply;
	
	public class MenuItem extends Sprite implements IMenuItem
	{
		public var menu:Menu;
		private var _subMenu:Menu;
		
		private var subMenuIcon:DisplayObject;
		
		private var tf:TextField;
		
		public var data:*;
		public var handler:Object;
		
		private var _width:Number = 0;
		
		public function MenuItem()
		{
			tf = DrawTool.CreateTextField(this);
			tf.y = 2;
			addEventListener(MouseEvent.ROLL_OVER, __onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, __onMouseOut);
			addEventListener(MouseEvent.CLICK, __onClick);
		}
		
		public function get subMenu():Menu
		{
			return _subMenu;
		}

		public function set subMenu(value:Menu):void
		{
			_subMenu = value;
			
			if(_subMenu != null){
				if(subMenuIcon == null){
					subMenuIcon = DrawTool.CreateIcon();
				}
				if(subMenuIcon.parent != this){
					addChild(subMenuIcon);
				}
			}else if(subMenuIcon && subMenuIcon.parent == this){
				removeChild(subMenuIcon);
			}
		}

		private function __onClick(evt:MouseEvent):void
		{
			evt.stopPropagation();
			var item:MenuItem = evt.currentTarget as MenuItem;
			if(item.subMenu){
				return;
			}
			var testItem:MenuItem = item;
			while(testItem != null){
				testItem.menu.clickSignal.notify(item);
				testItem = testItem.menu.parent as MenuItem;
			}
			lambda.apply(item.handler);
		}
		
		public function get enabled():Boolean
		{
			return true;
		}
		
		public function set enabled(value:Boolean):void
		{
			
		}
		
		public function get checked():Boolean
		{
			return false;
		}
		
		public function set checked(value:Boolean):void
		{
			
		}
		
		public function get label():String
		{
			return tf.text;
		}
		
		public function set label(value:String):void
		{
			tf.text = value;
		}
		
		private function __onMouseOver(evt:MouseEvent):void
		{
			drawBG(0x91C9F7, 1);
			if(subMenu != null){
				subMenu.show(this, _width);
			}
		}
		
		private function __onMouseOut(evt:MouseEvent):void
		{
			drawBG();
			if(subMenu != null){
				removeChild(subMenu);
			}
		}
		
		public function getWidth():Number
		{
			return tf.width;
		}
		
		public function getHeight():Number
		{
			return tf.height + 4;
		}
		
		private function drawBG(color:uint=0, alpha:Number=0):void
		{
			DrawTool.DrawMenuItemBG(graphics, _width, getHeight(), color, alpha);
		}
		
		public function render(menu:Menu, maxWidth:Number, nextY:Number):void
		{
			tf.x = menu.marginLeft;
			y = nextY;
			_width = maxWidth;
			drawBG();
			
			if(_subMenu != null){
				subMenuIcon.x = _width - 10;
				subMenuIcon.y = 0.5 * (getHeight() - subMenuIcon.height);
			}
		}
	}
}