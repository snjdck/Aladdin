package snjdck.utils
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="timer", type="flash.events.TimerEvent")]
	[Event(name="timerComplete", type="flash.events.TimerEvent")]
	
	public class GameTimer extends EventDispatcher
	{
		static private function getNowTime():Number
		{
			var date:Date = new Date();
			return date.time;
		}
		
		private var timer:Timer;
		private var delay:Number;
		
		private var repeatCount:int;
		private var currentCount:int;
		
		private var startTime:Number;
		
		public function GameTimer(delay:Number, repeatCount:int=0)
		{
			this.delay = delay;
			this.repeatCount = repeatCount;
			timer = new Timer(delay);
		}
		
		private function __onTimer(event:TimerEvent):void
		{
			onTick(getNowTime());
		}
		
		public function start():void
		{
			if(timer.running){
				return;
			}
			currentCount = 0;
			startTime = getNowTime();
			timer.addEventListener(TimerEvent.TIMER, __onTimer);
			timer.start();
		}
		
		public function stop():void
		{
			if(timer.running == false){
				return;
			}
			timer.removeEventListener(TimerEvent.TIMER, __onTimer);
			timer.stop();
		}
		
		public function get running():Boolean
		{
			return timer.running;
		}
		
		private function onTick(nowTime:Number):void
		{
			var count:int = (nowTime - startTime) / delay;
			
			while(currentCount < count){
				++currentCount;
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				
				//timer事件处理函数中可能会调用stop()
				if(timer.running == false){
					return;
				}
				
				if(isComplete()){
					stop();
					dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
					return;
				}
			}
		}
		
		private function isComplete():Boolean
		{
			return repeatCount > 0 && currentCount >= repeatCount;
		}
	}
}