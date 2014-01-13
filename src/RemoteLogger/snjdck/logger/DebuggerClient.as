package snjdck.logger
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class DebuggerClient extends Proxy
	{
		private var connection:LocalConnection;
		private var serverName:String;
		
		public function DebuggerClient(serverName:String)
		{
			connection = new LocalConnection();
			connection.addEventListener(StatusEvent.STATUS, __onStatus);
			this.serverName = serverName;
		}
		
		private function __onStatus(evt:StatusEvent):void
		{
		}
		
		override flash_proxy function callProperty(name:*, ...args):*
		{
			args.unshift(serverName, name);
			connection.send.apply(null, args);
		}
	}
}