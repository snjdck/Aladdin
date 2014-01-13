package snjdck.utils
{
	import flash.utils.getTimer;

	final public class StopWatch
	{
		private var totalTime:int;
		private var timestamp:int;
		
		public function StopWatch(totalTime:int)
		{
			this.totalTime = totalTime;
			reset();
		}
		
		public function reset():void
		{
			timestamp = getTimer();
		}
		
		public function get timeElapsed():int
		{
			return getTimer() - timestamp;
		}
		
		public function get timeElapsedPercent():Number
		{
			return timeElapsed / totalTime;
		}
		
		public function get timeElapsedPercentInfo():String
		{
			return int(timeElapsedPercent*100) + "%";
		}
		
		public function isEnough(time:int):Boolean
		{
			return timeElapsed >= time;
		}
		
		public function canTick():Boolean
		{
			return isEnough(totalTime);
		}
	}
}