package flash.tcp
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import flash.utils.IDataOutput;
	
	internal class TCPSocket
	{		
		private const _connectSignal:Signal = new Signal();
		private const _closeSignal:Signal = new Signal();
		private const _errorSignal:Signal = new Signal(String);
		
		protected var socket:Socket;
		
		private var host:String;
		private var port:int;
		
		public function TCPSocket(sock:Socket)
		{
			socket = sock || new Socket();
			init();
		}
		
		private function init():void
		{
			socket.addEventListener(IOErrorEvent.IO_ERROR, 				__onEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	__onEvent);
			socket.addEventListener(Event.CLOSE, 						__onEvent);
			socket.addEventListener(Event.CONNECT, 						__onEvent);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, 			__onEvent);
		}
		
		private function __onEvent(evt:Event):void
		{
			switch(evt.type)
			{
				case ProgressEvent.SOCKET_DATA:
					__onSocketData();
					break;
				case Event.CONNECT:
					__onConnect();
					_connectSignal.notify();
					break;
				case Event.CLOSE:
					_closeSignal.notify();
					break;
				default:
					_errorSignal.notify(evt.toString());
			}
		}
		
		/** 用于某些平台接入需要写入一些额外字节时,如TGW头 */
		public function getOutputChannel():IDataOutput
		{
			return socket;
		}
		
		public function get connected():Boolean
		{
			return socket.connected;
		}
		
		public function connect(host:String, port:int):void
		{
			this.host = host;
			this.port = port;
			socket.connect(host, port);
		}
		
		/** @param server 127.0.0.1:7777 */
		public function connect2(server:String):void
		{
			connect.apply(this, server.split(":"));
		}
		
		public function reconnect():void
		{
			if(!socket.connected){
				socket.connect(host, port);
			}
		}
		
		public function close():void
		{
			socket.close();
		}
		
		protected function __onConnect():void
		{
		}
		
		protected function __onSocketData():void
		{
		}
		
		public function toString():String
		{
			return "[Socket(" + host + ":" + port + ")]";
		}

		public function get connectSignal():ISignal
		{
			return _connectSignal;
		}

		public function get closeSignal():ISignal
		{
			return _closeSignal;
		}

		public function get errorSignal():ISignal
		{
			return _errorSignal;
		}
	}
}