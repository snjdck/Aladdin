package snjdck.ui.slider
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import snjdck.ui.Component;
	
	[ExcludeClass]
	[Event(name="scroll", type="flash.events.Event")]
	public class Slider extends Component
	{
		public var thumb:Sprite;
		public var track:Sprite;
		
		private var _viewSize:Number = 0;
		private var _pageSize:Number = 1;
		
		private var _value:Number = 0;
		
		public function Slider()
		{
			_width = track.width;
			_height = track.height;
			
			new SliderTrackEventHandler(this);
			new SliderThumbEventHandler(this);
		}
		
		public function set value(newValue:Number):void
		{
			_value = (newValue > 1) ? 1 : (newValue < 0 ? 0 : newValue);
			updateUI_ThumbXY();
			dispatchEvent(new Event(Event.SCROLL, true));
		}
		
		private function updateThumbSize(prevPageViewDiff:Number):void
		{
			if(canScroll()){
				value *= prevPageViewDiff / calcPageViewSizeDiff();
				updateUI_ThumbWH();
				thumb.visible = true;
			}else{
				value = 0;
				thumb.visible = false;
			}
		}
		
		public function scroll(stepSize:Number):void
		{
			if(canScroll()){
				value += stepSize / calcPageViewSizeDiff();
			}
		}
		
		public function set viewSize(value:Number):void
		{
			if(viewSize == value){
				return;
			}
			var prevPageViewDiff:Number = calcPageViewSizeDiff();
			_viewSize = value;
			updateThumbSize(prevPageViewDiff);
		}
		
		public function set pageSize(value:Number):void
		{
			if(pageSize == value){
				return;
			}
			var prevPageViewDiff:Number = calcPageViewSizeDiff();
			_pageSize = value;
			updateThumbSize(prevPageViewDiff);
		}
		
		public function get thumbSize():Number
		{
			return (viewSize / pageSize) * length;
		}
		
		public function get maxThumbLocation():Number
		{
			return length - thumbSize;
		}
		
		public function canScroll():Boolean
		{
			return pageSize > viewSize;
		}
		
		public function calcPageViewSizeDiff():Number
		{
			return pageSize - viewSize;
		}
		
		public function get value():Number{return _value;}
		public function get viewSize():Number{return _viewSize;}
		public function get pageSize():Number{return _pageSize;}
		virtual protected function updateUI_ThumbXY():void{}
		virtual protected function updateUI_ThumbWH():void{}
		virtual internal function calcMoveOffset(offsetX:Number, offsetY:Number):Number{return 0;}
		virtual internal function isIncreaseDirection():Boolean{return true;}
		virtual public function get length():Number{return 0;}
		virtual public function set length(value:Number):void
		{
			updateThumbSize(calcPageViewSizeDiff());
		}
	}
}