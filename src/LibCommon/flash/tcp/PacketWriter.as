package flash.tcp
{
	import flash.utils.IDataOutput;

	final internal class PacketWriter extends PacketIO
	{
		private var socket:IDataOutput;
		
		public function PacketWriter(socket:IDataOutput)
		{
			this.socket = socket;
		}
		
		public function writePacketsToOutputCache():void
		{
			while(hasPacket()){
				getPacket().write(socket);
			}
		}
	}
}