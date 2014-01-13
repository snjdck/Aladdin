package snjdck.signal
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class EventSignal extends Signal
	{
		private var target:IEventDispatcher;
		private var evtType:String;
		
		public function EventSignal(target:IEventDispatcher, evtType:String)
		{
			this.target = target;
			this.evtType = evtType;
			super(Event);
			bind();
		}
		
		private function __onEvent(evt:Event):void
		{
			notify(evt);
		}
		
		public function bind():void
		{
			target.addEventListener(evtType, __onEvent);
		}
		
		public function unbind():void
		{
			target.removeEventListener(evtType, __onEvent);
		}
	}
}