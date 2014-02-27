package flash.tcp
{
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	
	import flash.signals.ISignal;
	import flash.signals.Signal;

	final public class TcpServer
	{
		private var serverSocket:ServerSocket;
		private var _clientConnectSignal:Signal;
		
		public function TcpServer(port:int)
		{
			serverSocket = new ServerSocket();
			serverSocket.bind(port);
			
			_clientConnectSignal = new Signal(Socket);
		}
		
		public function get clientConnectSignal():ISignal
		{
			return _clientConnectSignal;
		}
		
		public function listen():void
		{
			serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, __onClientConnect);
			serverSocket.listen();
		}
		
		public function close():void
		{
			serverSocket.close();
		}
		
		private function __onClientConnect(evt:ServerSocketConnectEvent):void
		{
			_clientConnectSignal.notify(evt.socket);
		}
	}
}