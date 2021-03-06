package flash.tcp.router
{
	import flash.lang.ISerializable;
	import flash.tcp.IPacket;
	import flash.tcp.error.PacketError;
	import flash.tcp.error.PacketErrorDict;

	internal class RequestInfo
	{
		private var requestId:uint;
		private var requestType:Class;
		
		private var responseId:uint;
		private var responseType:Class;
		
		private var errorId:uint;
		
		private const callbackList:Array = [];
		
		public function RequestInfo(requestId:uint, requestType:Class, responseId:uint, responseType:Class, errorId:uint)
		{
			this.requestId = requestId;
			this.requestType = requestType;
			this.responseId = responseId;
			this.responseType = responseType;
			this.errorId = errorId;
		}
		
		public function hasResponse():Boolean
		{
			return (responseId > 0) || (errorId > 0);
		}
		
		public function addCallback(callback:CallbackTrait):void
		{
			callbackList.push(callback);
		}
		
		public function call(packet:IPacket, packetErrorDict:PacketErrorDict):void
		{
			var trait:CallbackTrait = callbackList.shift();
			
			if(packet.msgId == errorId){
				$lambda.call(trait.onError, packetErrorDict.fetch(packet.errorId));
				return;
			}
			var response:ISerializable = new responseType();
			response.readFrom(packet.msgData);
			if(packet.msgData != null){
				assert(packet.msgData.bytesAvailable == 0, "封包中有冗余数据!");
			}
			$lambda.call(trait.onSuccess, response);
		}
		
		public function checkTimeout(now:int, requestTimeoutError:PacketError):void
		{
			while(callbackList.length > 0){
				var trait:CallbackTrait = callbackList[0];
				if(now - trait.timestamp < 10000){
					return;//如果前面的都没超时,后面的也肯定没有超时
				}
				callbackList.shift();
				$lambda.call(trait.onError, requestTimeoutError);
			}
		}
	}
}