package snjdck.g3d.events
{
	import flash.events.Event;
	
	public class Event3D extends Event
	{
		private var evtTarget:Object;
		
		public function Event3D(type:String, evtTarget:Object)
		{
			super(type);
			this.evtTarget = evtTarget;
		}
		
		override public function clone():Event
		{
			return new Event3D(type, evtTarget);
		}
		
		override public function get target():Object
		{
			return evtTarget;
		}
	}
}