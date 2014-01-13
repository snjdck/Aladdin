package ui.scrollpane
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import ui.core.Component;
	import ui.core.Container;
	
	public class ScrollPane extends Container
	{
		private var _scrollBar:ScrollBar;
		
		public function ScrollPane()
		{
			scrollBar.addEventListener(Event.SCROLL, __onScroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
			
			addEventListener(Event.ADDED, __onChildChanged);
			addEventListener(Event.REMOVED, __onChildChanged);
			
			scrollBar.arrowStepSize = 10;
			scrollBar.trackStepSize = 20;
		}
		
		private function __onChildChanged(event:Event):void
		{
			var child:DisplayObject = event.target as DisplayObject;
			if(contains(child)){
				setTimeout(__onViewAreaChange, 0);
			}
		}
		
		override public function onResize():void
		{
			super.onResize();
			scrollBar.x = width;
			scrollBar.height = height;
			scrollBar.viewSize = height;
			scrollRect = new Rectangle(0, 0, width+scrollBar.width, height);
		}
		
		public function get scrollV():Number
		{
			return scrollBar.scrollV;
		}
		
		public function set scrollV(value:Number):void
		{
			scrollBar.scrollV = value;
		}
		
		public function get scrollBar():ScrollBar
		{
			return _scrollBar;
		}
		
		override protected function createChildren():void
		{ 
			_scrollBar = new ScrollBar();
			scrollBar.visible = false;
			$_addChild(scrollBar);
		}
		
		private function __onViewAreaChange():void
		{
			scrollBar.pageSize = contentHeight;
			scrollBar.visible = scrollBar.canScroll();
		}
		
		private function __onMouseWheel(event:MouseEvent):void
		{
			scrollBar.scroll(scrollBar.arrowStepSize * -event.delta);
		}
		
		private function __onScroll(event:Event):void
		{
			contentY = scrollBar.scrollV * (height - contentHeight);
		}
	}
}