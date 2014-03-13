package flash.tcp.router
{
	internal class CallbackTrait
	{
		public var onSuccess:Object;
		public var onError:Object;
		
		public var timestamp:int;
		
		public function CallbackTrait(onSuccess:Object, onError:Object, timestamp:int)
		{
			this.onSuccess = onSuccess;
			this.onError = onError;
			this.timestamp = timestamp;
		}
	}
}