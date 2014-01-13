package ui.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		private var _data:Object;
		
		public function DataEvent(type:String, data:Object)
		{
			super(type);
			this._data = data;
		}
		
		public function get data():*
		{
			return _data;
		}
		
		override public function clone():Event
		{
			return new DataEvent(type, data);
		}
	}
}