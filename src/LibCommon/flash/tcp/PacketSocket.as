package flash.tcp
{
	import flash.tcp.io.PacketReader;
	import flash.tcp.io.PacketWriter;
	import flash.tcp.router.PacketRouter;
	import flash.utils.ByteArray;

	final public class PacketSocket extends TCPSocket implements IPacketRouter
	{
		static public var ERROR_ID_REQUEST_TIMEOUT:uint;
		
		private var packetReader:PacketReader;
		private var packetWriter:PacketWriter;
		private var packetRouter:PacketRouter;
		
		private var packetFactory:IPacket;
		
		public function PacketSocket(packet:IPacket)
		{
			packetFactory = packet.create();
			packetReader = new PacketReader(socket, packet);
			packetWriter = new PacketWriter(socket);
			packetRouter = new PacketRouter();
			socket.endian = packet.endian;
		}
		
		public function send(msgId:uint, msgData:ByteArray):void
		{
			var packet:IPacket = packetFactory.create(msgId, msgData);
			packetWriter.addPacket(packet);
			packetRouter.checkTimeout();
		}
		
		public function flush():void
		{
			if(connected && packetWriter.hasPacket()){
				packetWriter.writePacketsToOutputCache();
				socket.flush();
			}
		}
		
		override protected function __onConnect():void
		{
			flush();
		}
		
		override protected function __onSocketData():void
		{
			packetReader.readPacketsFromInputCache();
			while(packetReader.hasPacket()){
				packetRouter.routePacket(packetReader.getPacket());
			}
			packetRouter.checkTimeout();
		}
		
		public function regRequest(requestId:uint, requestType:Class, responseId:uint=0, responseType:Class=null, errorId:uint=0):void
		{
			packetRouter.regRequest(requestId, requestType, responseId, responseType, errorId);
		}
		
		/** function handler(Object):void */
		public function regNotice(noticeId:uint, noticeType:Class, handler:Object):void
		{
			packetRouter.regNotice(noticeId, noticeType, handler);
		}
		
		public function request(message:Object, onSuccess:Object=null, onError:Object=null):void
		{
			var requestId:uint = packetRouter.fetchRequestId(message);
			packetRouter.listenResponse(requestId, onSuccess, onError);
			
			var msgData:ByteArray = new ByteArray();
			msgData.endian = socket.endian;
			message.writeTo(msgData);
			send(requestId, msgData);
			
			flush();
		}
	}
}