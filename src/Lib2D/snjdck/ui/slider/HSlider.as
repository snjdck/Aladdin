package snjdck.ui.slider
{
	public class HSlider extends Slider
	{
		public function HSlider(){}
		
		override public function get length():Number
		{
			return _width;
		}
		
		override public function set length(value:Number):void
		{
			_width = value;
			track.width = value;
			super.length = value;
		}
		
		override public function set width(value:Number):void
		{
			length = value;
		}
		
		override public function set height(value:Number):void
		{
		}
		
		override protected function updateUI_ThumbXY():void
		{
			thumb.x = value * maxThumbLocation;
		}
		
		override protected function updateUI_ThumbWH():void
		{
			thumb.width = thumbSize;
		}
		
		override internal function calcMoveOffset(offsetX:Number, offsetY:Number):Number
		{
			return offsetX;
		}
		
		override internal function isIncreaseDirection():Boolean
		{
			return mouseX > thumb.x;
		}
	}
}