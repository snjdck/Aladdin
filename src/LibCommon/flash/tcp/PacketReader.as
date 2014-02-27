package flash.tcp
{
	import flash.utils.IDataInput;

	final internal class PacketReader extends PacketIO
	{
		private var socket:IDataInput;
		private var packet:IPacket;
		/** 数据不足 */
		private var isWaiting:Boolean;
		
		public function PacketReader(socket:IDataInput, packet:IPacket)
		{
			this.socket = socket;
			this.packet = packet;
		}
		
		public function readPacketsFromInputCache():void
		{
			if(isWaiting){
				readPacketBody();
			}else if(socket.bytesAvailable >= packet.headSize){
				packet.readHead(socket);
				readPacketBody();
			}
		}
		
		private function readPacketBody():void
		{
			if(socket.bytesAvailable < packet.bodySize){
				isWaiting = true;
				return;
			}
			if(packet.bodySize > 0){
				packet.readBody(socket);
			}
			addPacket(packet);
			packet = packet.create();
			isWaiting = false;
			readPacketsFromInputCache();
		}
	}
}