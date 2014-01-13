package ui.events
{
	import flash.events.Event;
	
	public class TabedPaneEvent extends Event
	{
		static public const TAB_FOCUS_IN:String = "tabFocusIn";
		static public const TAB_FOCUS_OUT:String = "tabFocusOut";
		
		private var _tabIndex:int;
		
		public function TabedPaneEvent(type:String, tabIndex:int)
		{
			super(type);
			this._tabIndex = tabIndex;
		}
		
		public function get tabIndex():int
		{
			return _tabIndex;
		}
		
		override public function clone():Event
		{
			return new TabedPaneEvent(type, tabIndex);
		}
	}
}