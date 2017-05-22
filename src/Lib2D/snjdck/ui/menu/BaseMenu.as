package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	import snjdck.ui.DrawObject;
	
	internal class BaseMenu extends DrawObject
	{
		private const useCapture:Boolean = true;
		
		public const clickSignal:Signal = new Signal(Object);
		public const closeSignal:Signal = new Signal(Boolean);
		internal var mouseHitTarget:DisplayObjectContainer;
		
		public function BaseMenu()
		{
		}
		
		public function removeOtherMenus(parent:DisplayObjectContainer):void
		{
			for(var i:int=parent.numChildren-1; i>=0; --i){
				var menu:BaseMenu = parent.getChildAt(i) as BaseMenu;
				if(menu != null){
					menu.onClose(false);
				}
			}
		}
		
		public function listenCloseEvents():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, useCapture);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, __onMouseDown, useCapture);
			clickSignal.add(onSelect);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			var target:DisplayObjectContainer = mouseHitTarget || this;
			if(!target.contains(evt.target as DisplayObject)){
				onClose(true);
			}
		}
		
		private function onSelect(_:Object):void
		{
			onClose(true);
		}
		
		private function onClose(isCloseByUser:Boolean):void
		{
			clickSignal.del(onSelect);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, useCapture);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, __onMouseDown, useCapture);
			parent.removeChild(this);
			mouseHitTarget = null;
			closeSignal.notify(isCloseByUser);
		}
	}
}