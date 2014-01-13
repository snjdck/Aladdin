package snjdck.logger
{
	import flash.net.LocalConnection;

	public class DebuggerServer
	{
		private var connection:LocalConnection;
		
		public function DebuggerServer(serverName:String)
		{
			connection = new LocalConnection();
			connection.allowDomain("*");
			connection.allowInsecureDomain("*");
			connection.client = {};
			connection.connect(serverName);
		}
		
		public function regHandler(methodName:String, methodRef:Function):void
		{
			connection.client[methodName] = methodRef;
		}
	}
}