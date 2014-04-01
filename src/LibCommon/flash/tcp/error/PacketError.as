package flash.tcp.error
{
	public class PacketError extends Error
	{
		public function PacketError(message:String, id:int)
		{
			super(message, id);
		}
	}
}