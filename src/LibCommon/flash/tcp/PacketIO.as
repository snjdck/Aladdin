package flash.tcp
{
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
		
		public function getPacket():IPacket
		{
			return packetList.shift();
		}
	}
}