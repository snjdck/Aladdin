package flash.tcp.io
{
	import flash.tcp.IPacket;

	internal class PacketIO
	{
		private var packetList:Vector.<IPacket>;
		
		public function PacketIO()
		{
			packetList = new <IPacket>[];
		}
		
		public function addPacket(packet:IPacket):void
		{
			packetList.push(packet);
		}
		
		public function hasPacket():Boolean
		{
			return packetList.length > 0;
		}
		
		public function shiftPacket():IPacket
		{
			return packetList.shift();
		}
	}
}