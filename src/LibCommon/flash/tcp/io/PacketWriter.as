package flash.tcp.io
{
	import flash.utils.IDataOutput;

	final public class PacketWriter extends PacketIO
	{
		private var socket:IDataOutput;
		
		public function PacketWriter(socket:IDataOutput)
		{
			this.socket = socket;
		}
		
		public function writePacketsToOutputCache():void
		{
			while(hasPacket()){
				shiftPacket().write(socket);
			}
		}
	}
}