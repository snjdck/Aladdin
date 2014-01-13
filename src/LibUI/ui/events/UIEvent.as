package ui.events
{
	import flash.events.Event;
	
	internal class UIEvent extends Event
	{
		static public const UI_POSITION_CHANGE:String = "uiPositionChange";
		static public const UI_SIZE_CHANGE:String = "uiSizeChange";
		
		public function UIEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new UIEvent(type);
		}
	}
}