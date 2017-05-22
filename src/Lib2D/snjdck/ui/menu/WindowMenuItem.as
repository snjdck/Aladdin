package snjdck.ui.menu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class WindowMenuItem extends Sprite
	{
		public var colorHover:uint = 0xCCE8FF;
		public var colorOut:uint = 0xE5F3FF;
		
		private var tf:TextField;
		internal var windowMenu:WindowMenu;
		private var menu:Menu;
		
		public function WindowMenuItem(label:String, menu:Menu)
		{
			tf = DrawTool.CreateTextField(this);
			tf.text = label;
			
			this.menu = menu;
			
			addEventListener(MouseEvent.CLICK, __onClick);
			addEventListener(MouseEvent.ROLL_OVER, __onMouseOver);
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			windowMenu.showMenuFlag = !windowMenu.showMenuFlag;
			active();
		}
		
		private function __onMouseOver(evt:MouseEvent):void
		{
			if(windowMenu.focusItem == this){
				return;
			}
			if(windowMenu.focusItem != null){
				windowMenu.focusItem.onFocusOut();
			}
			windowMenu.focusItem = this;
			active();
		}
		
		private function active():void
		{
			menu.removeOtherMenus(parent);
			if(windowMenu.showMenuFlag){
				drawBG(colorHover);
				showMenu();
			}else{
				drawBG(colorOut);
			}
		}
		
		private function showMenu():void
		{
			menu.show(parent, x, tf.height);
			menu.mouseHitTarget = parent;
			menu.listenCloseEvents();
			menu.closeSignal.add(__onMenuClose, true);
		}
		
		private function __onMenuClose(isCloseByUser:Boolean):void
		{
			onFocusOut();
			if(isCloseByUser){
				windowMenu.showMenuFlag = false;
				windowMenu.focusItem = null;
			}
		}
		
		internal function onFocusOut():void
		{
			graphics.clear();
		}
		
		private function drawBG(color:uint):void
		{
			DrawTool.DrawMenuItemBG(graphics, tf.width, tf.height, color, 1);
		}
	}
}