package flash.tcp.router
{
	import dict.hasKey;
	
	import flash.reflection.getType;
	import flash.reflection.getTypeName;
	import flash.tcp.IPacket;
	import flash.tcp.error.PacketError;
	import flash.tcp.error.PacketErrorDict;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import string.replace;

	final public class PacketRouter
	{
		private const requestTypeDict:Object = new Dictionary();
		private const requestDict:Object = new Dictionary();
		private const responseDict:Object = new Dictionary();
		
		private var packetErrorDict:PacketErrorDict;
		
		public function PacketRouter(packetErrorDict:PacketErrorDict)
		{
			this.packetErrorDict = packetErrorDict;
		}
		
		public function routePacket(packet:IPacket):void
		{
			var msgId:uint = packet.msgId;
			assert(hasKey(responseDict, msgId), replace("msgId=${0} has not been registered yet!", [msgId]));
			var info:Object = responseDict[msgId];
			
			if(info is NoticeInfo){
				var noticeInfo:NoticeInfo = info as NoticeInfo;
				noticeInfo.call(packet.msgData);
				return;
			}
			if(info is RequestInfo){
				var requestInfo:RequestInfo = info as RequestInfo;
				requestInfo.call(packet, packetErrorDict);
				return;
			}
			assert(false, "what fuck is info?");
		}
		
		public function fetchRequestId(msgData:Object):uint
		{
			var msgType:Class = getType(msgData);
			assert(hasKey(requestTypeDict, msgType), replace("msgType='${0}' has not been registered yet!", [getTypeName(msgData)]));
			return requestTypeDict[msgType];
		}
		
		public function listenResponse(requestId:uint, onSuccess:Object, onError:Object=null):void
		{
			var requestInfo:RequestInfo = requestDict[requestId];
			assert(requestInfo != null, replace("msgId='${0}' has not been registered yet!", [requestId]));
			if(requestInfo.hasResponse()){
				requestInfo.addCallback(new CallbackTrait(onSuccess, onError, getTimer()));
			}
		}
		
		public function regNotice(noticeId:uint, noticeType:Class, handler:Object):void
		{
			var info:NoticeInfo = new NoticeInfo(noticeId, noticeType, handler);
			addKey(responseDict, noticeId, info);
		}
		
		public function regRequest(requestId:uint, requestType:Class, responseId:uint, responseType:Class, errorId:uint):void
		{
			var info:RequestInfo = new RequestInfo(requestId, requestType, responseId, responseType, errorId);
			addKey(requestTypeDict, requestType, requestId);
			addKey(requestDict, requestId, info);
			if(responseId > 0){
				addKey(responseDict, responseId, info);
			}
			if(errorId > 0){
				addKey(responseDict, errorId, info);
			}
		}
		
		static private function addKey(target:Object, key:Object, value:Object):void
		{
			assert(!hasKey(target, key), replace("key='${0}' has exist!", [key]));
			target[key] = value;
		}
		
		public function checkTimeout():void
		{
			var requestTimeoutError:PacketError = packetErrorDict.fetchRequestTimeoutError();
			var now:int = getTimer();
			for each(var requestInfo:RequestInfo in requestDict){
				requestInfo.checkTimeout(now, requestTimeoutError);
			}
		}
	}
}