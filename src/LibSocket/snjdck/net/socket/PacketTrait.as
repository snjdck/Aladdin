package snjdck.net.socket
{
	final internal class PacketTrait
	{
		public var packet:IPacket;
		public var callback:Object;
		public var timestamp:int;
		
		public function PacketTrait(packet:IPacket, callback:Object, timestamp:int)
		{
			this.packet = packet;
			this.callback = callback;
			this.timestamp = timestamp;
		}
	}
}