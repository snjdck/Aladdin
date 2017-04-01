package snjdck.ui.slider
{
	public class VSlider extends Slider
	{
		public function VSlider(){}
		
		override public function get length():Number
		{
			return _height;
		}
		
		override public function set length(value:Number):void
		{
			_height = value;
			track.height = value;
			super.length = value;
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
			length = value;
		}
		
		override protected function updateUI_ThumbXY():void
		{
			thumb.y = value * maxThumbLocation;
		}
		
		override protected function updateUI_ThumbWH():void
		{
			thumb.height = thumbSize;
		}
		
		override internal function calcMoveOffset(offsetX:Number, offsetY:Number):Number
		{
			return offsetY;
		}
		
		override internal function isIncreaseDirection():Boolean
		{
			return mouseY > thumb.y;
		}
	}
}