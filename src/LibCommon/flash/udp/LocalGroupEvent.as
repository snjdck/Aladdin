package flash.udp
{
	import flash.events.Event;
	
	public class LocalGroupEvent extends Event
	{
		static public const CONNECT:String = "connect";
		static public const DISCONNECT:String = "disconnect";
		static public const MESSAGE:String = "message";
		static public const INIT:String = "init";
		
		public var address:String;
		public var msg:Object;
		
		public function LocalGroupEvent(type:String, address:String=null, msg:Object=null)
		{
			super(type);
			this.address = address;
			this.msg = msg;
		}
		
		override public function clone():Event
		{
			return new LocalGroupEvent(type, address, msg);
		}
	}
}