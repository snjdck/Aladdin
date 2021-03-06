package flash.tcp.error
{
	import flash.utils.Dictionary;

	public class PacketErrorDict
	{
		static private const requestTimeoutError:PacketError = new PacketError("request timeout!", 0);
		private const errorDict:Object = new Dictionary();
		
		public function PacketErrorDict()
		{
		}
		
		public function register(errorId:int, message:String):void
		{
			assert($dict.hasKey(errorDict, errorId) == false, "errorId repeat!");
			errorDict[errorId] = new PacketError(message, errorId);
		}
		
		public function fetch(errorId:int):PacketError
		{
			assert($dict.hasKey(errorDict, errorId), "errorId has not register yet!");
			return errorDict[errorId];
		}
		
		public function fetchRequestTimeoutError():PacketError
		{
			return requestTimeoutError;
		}
	}
}