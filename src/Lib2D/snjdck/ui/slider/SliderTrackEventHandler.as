package snjdck.ui.slider
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.support.StepTimer;

	internal class SliderTrackEventHandler
	{
		private var slider:Slider;
		private var track:Sprite;
		
		private var delayTimer:StepTimer;
		
		public function SliderTrackEventHandler(slider:Slider)
		{
			this.slider = slider;
			this.track = slider.track;
			
			track.addEventListener(MouseEvent.MOUSE_DOWN, __onTrackMouseDown);
			
			delayTimer = new StepTimer(500, 50);
			delayTimer.addEventListener(TimerEvent.TIMER, __onTimerTrigged);
		}
		
		private function __onTimerTrigged(evt:Event):void
		{
			slider.scroll(slider.viewSize * (slider.isIncreaseDirection() ? 1 : -1));
		}
		
		private function __onTrackMouseDown(evt:MouseEvent):void
		{
			track.addEventListener(MouseEvent.MOUSE_OUT, __onTrackMouseUp);
			track.addEventListener(MouseEvent.MOUSE_UP, __onTrackMouseUp);
			delayTimer.start();
			__onTimerTrigged(null);
		}
		
		private function __onTrackMouseUp(evt:MouseEvent):void
		{
			track.removeEventListener(MouseEvent.MOUSE_OUT, __onTrackMouseUp);
			track.removeEventListener(MouseEvent.MOUSE_UP, __onTrackMouseUp);
			delayTimer.stop();
		}
	}
}