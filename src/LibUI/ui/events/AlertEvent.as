package ui.events
{
	import flash.events.Event;

	public class AlertEvent extends Event
	{
		static public const BTN_CLOSE:int = 1;
		static public const BTN_OK:int = 2;
		static public const BTN_CANCEL:int = 3;
		
		static public const CLOSE:String = "close";
		
		private var _buttonCode:int;
		
		public function AlertEvent(type:String, buttonCode:int)
		{
			super(type);
			this._buttonCode = buttonCode;
		}
		
		public function get buttonCode():int
		{
			return _buttonCode;
		}
		
		override public function clone():Event
		{
			return new AlertEvent(type, buttonCode);
		}
	}
}