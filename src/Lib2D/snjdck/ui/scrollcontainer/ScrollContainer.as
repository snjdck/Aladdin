package snjdck.ui.scrollcontainer
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import snjdck.ui.Component;
	import snjdck.ui.scrollable.IScrollAdapter;
	import snjdck.ui.slider.Slider;
	
	[ExcludeClass]
	public class ScrollContainer extends Component
	{
		private var adapter:IScrollAdapter;
		protected var scrollBar:Slider;
		
		public function ScrollContainer(adapter:IScrollAdapter, scrollBar:Slider)
		{
			this.adapter = adapter;
			this.scrollBar = scrollBar;
			
			_width = adapter.displayObject.width;
			_height = adapter.displayObject.height;
			
			addChild(adapter.displayObject);
			addChild(scrollBar);
			
			scrollBar.viewSize = adapter.viewSizeY;
			scrollBar.pageSize = adapter.pageSizeY;
			scrollBar.addEventListener(Event.SCROLL, __onScroll);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
		}
		
		private function __onScroll(evt:Event):void
		{
			adapter.updateViewY(scrollBar.value);
		}
		
		private function __onMouseWheel(evt:MouseEvent):void
		{
			scrollBar.value -= evt.delta / scrollBar.calcPageViewSizeDiff();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			adapter.updateViewW(value);
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			adapter.updateViewH(value);
		}
		
		protected function updateScrollBarLength(value:Number):void
		{
			scrollBar.viewSize = adapter.viewSizeY;
			scrollBar.length = value;
			scrollBar.visible = scrollBar.canScroll();
		}
	}
}