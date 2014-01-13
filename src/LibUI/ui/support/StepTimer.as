package ui.support
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="timer", type="flash.events.TimerEvent")]
	
	public class StepTimer extends EventDispatcher
	{
		private var delay:Number;
		private var interval:Number;
		private var isDelayMode:Boolean;
		private var timer:Timer;
		
		public function StepTimer(delay:Number, interval:Number)
		{
			this.delay = delay;
			this.interval = interval;
			
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, __onTimerTrigged);
			isDelayMode = true;
		}
		
		private function __onTimerTrigged(event:TimerEvent):void
		{
			if(isDelayMode){
				timer.delay = interval;
				isDelayMode = false;
			}
			dispatchEvent(event);
		}
		
		public function start():void
		{
			stop();
			timer.start();
		}
		
		public function stop():void
		{
			if(timer.running){
				isDelayMode = true;
				timer.reset();
				timer.delay = delay;
			}
		}
	}
}