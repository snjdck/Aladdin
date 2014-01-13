package snjdck.common
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		protected var _data:*;
		
		public function DataEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}
		
		override public function clone():Event
		{
			return new DataEvent(type, data, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("DataEvent", "type", "bubbles", "cancelable", "data");
		}
		
		public function get data():*
		{
			return this._data;
		}
	}
}