package flash.tcp.error
{
	import dict.hasKey;
	import dict.isEmpty;
	
	import flash.utils.Dictionary;

	public class PacketErrorDict
	{
		private const errorDict:Object = new Dictionary();
		private var requestTimeoutErrorId:int;
		
		public function PacketErrorDict()
		{
		}
		
		public function register(errorId:int, message:String):void
		{
			assert(dict.hasKey(errorDict, errorId) == false, "errorId repeat!");
			if(dict.isEmpty(errorDict)){
				requestTimeoutErrorId = errorId;
			}
			errorDict[errorId] = new PacketError(message, errorId);
		}
		
		public function fetch(errorId:int):PacketError
		{
			assert(dict.hasKey(errorDict, errorId), "errorId has not register yet!");
			return errorDict[errorId];
		}
		
		public function fetchRequestTimeoutError():PacketError
		{
			return fetch(requestTimeoutErrorId);
		}
	}
}