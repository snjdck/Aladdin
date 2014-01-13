package snjdck.events
{
	import flash.events.Event;
	
	import snjdck.common.DataEvent;
	
	public class TreeEvent extends DataEvent
	{
		private static const PREFIX:String = "TreeEvent_";
		
		public static const SELECTED:String		=	PREFIX + "SELECTED";
//		public static const UPDATE:String		=	PREFIX + "UPDATE";
//		public static const EXPAND:String		=	PREFIX + "EXPAND";
		public static const NODE_CLICK:String	=	PREFIX + "NODE_CLICK";
		public static const NODE_DOUBLE_CLICK:String	=	PREFIX + "NODE_DBCLICK";
		
		public function TreeEvent(type:String, data:* = null, bubbles:Boolean = false)
		{
			super(type, data, bubbles);
		}
		
		override public function clone():Event
		{
			return new TreeEvent(type, data, bubbles);
		}
		
		public function set data(value:*):void
		{
			_data = value;
		}
	}
}