package snjdck.net.socket
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	import snjdck.signal.ISignal;
	import snjdck.signal.Signal;
	
	internal class TCPSocket
	{		
		private const _connectSignal:Signal = new Signal();
		protected const _recvDataSignal:Signal = new Signal(uint, Object);
		private const _closeSignal:Signal = new Signal();
		private const _errorSignal:Signal = new Signal(String);
		
		protected var socket:Socket;
		
		private var host:String;
		private var port:int;
		
		public function TCPSocket()
		{
			socket = new Socket();
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
		
		public function get connected():Boolean
		{
			return socket.connected;
		}
		
		public function connect(host:String, port:int):void
		{
			this.host = host;
			this.port = port;
			reconnect();
		}
		
		/** @param server 127.0.0.1:7777 */
		public function connect2(server:String):void
		{
			connect.apply(this, server.split(":"));
		}
		
		public function reconnect():void
		{
			socket.connect(host, port);
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

		public function get recvDataSignal():ISignal
		{
			return _recvDataSignal;
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