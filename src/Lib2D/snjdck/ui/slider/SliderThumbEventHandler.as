package snjdck.ui.slider
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	internal class SliderThumbEventHandler
	{
		private var slider:Slider;
		private var thumb:Sprite;
		
		private var dragInitValue:Number;
		private var dragMouseX:Number;
		private var dragMouseY:Number;
		
		public function SliderThumbEventHandler(slider:Slider)
		{
			this.slider = slider;
			this.thumb = slider.thumb;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, __onThumbMouseDown);
		}
		
		private function __onThumbMouseDown(evt:MouseEvent):void
		{
			dragInitValue = slider.value;
			dragMouseX = evt.stageX;
			dragMouseY = evt.stageY;
			slider.stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			slider.stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			slider.value = dragInitValue + slider.calcMoveOffset(evt.stageX - dragMouseX, evt.stageY - dragMouseY) / slider.maxThumbLocation;
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			slider.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			slider.stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
	}
}