package flash.tcp
{
	import flash.tcp.io.PacketReader;
	import flash.tcp.io.PacketWriter;
	import flash.tcp.router.PacketRouter;

	final public class PacketSocket extends TCPSocket
	{
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
		}
		
		public function send(msgId:uint, msgData:Object, callback:Object=null, flushToServer:Boolean=false):void
		{
			var packet:IPacket = packetFactory.create(msgId, msgData);
			packetRouter.regRequestHandler(packet, callback);
			packetWriter.addPacket(packet);
			if(flushToServer){
				flush();
			}
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
				handlePacket(packetReader.getPacket());
			}
			packetRouter.checkTimeout();
		}
		
		private function handlePacket(packet:IPacket):void
		{
			if(packetRouter.hasRequestHandler(packet.msgId)){
				packetRouter.routeResponse(packet);
			}else{
				packetRouter.routeNotice(packet);
			}
		}
		
		/** function handler(Object):void */
		public function regNoticeHandler(msgId:uint, handler:Object):void
		{
			packetRouter.regNoticeHandler(msgId, handler);
		}
	}
}