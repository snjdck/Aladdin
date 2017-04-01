package snjdck.ui.scrollcontainer
{
	import snjdck.ui.scrollable.IScrollAdapter;
	import snjdck.ui.slider.VSlider;
	
	public class VScrollContainer extends ScrollContainer
	{
		public function VScrollContainer(adapter:IScrollAdapter, scrollBar:VSlider)
		{
			super(adapter, scrollBar);
			scrollBar.x = width;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			scrollBar.x = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			updateScrollBarLength(value);
		}
	}
}