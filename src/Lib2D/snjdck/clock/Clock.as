package snjdck.clock
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import array.del;
	import array.has;

	public class Clock implements IClock
	{
		static private var instance:Clock;
		
		static public function getInstance():IClock
		{
			if(null == instance){
				instance = new Clock();
			}
			return instance;
		}
		
		private const evtSource:IEventDispatcher = new Shape();
		private const tickerList:Vector.<ITicker> = new Vector.<ITicker>();
		private var timestamp:int;
		
		public function Clock()
		{
			evtSource.addEventListener(Event.ENTER_FRAME, __onTick);
			timestamp = getTimer();
		}
		
		private function __onTick(evt:Event):void
		{
			var now:int = getTimer();
			var timeElapsed:int = now - timestamp;
			timestamp = now;
			
			for each(var ticker:ITicker in tickerList){
				ticker.onTick(timeElapsed);
			}
		}
		
		public function add(ticker:ITicker):void
		{
			if(array.has(tickerList, ticker)){
				return;
			}
			tickerList[tickerList.length] = ticker;
		}
		
		public function remove(ticker:ITicker):void
		{
			array.del(tickerList, ticker);
		}
	}
}