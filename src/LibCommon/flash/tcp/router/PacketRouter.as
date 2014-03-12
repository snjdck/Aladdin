package flash.tcp.router
{
	import dict.hasKey;
	
	import flash.tcp.IPacket;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import lambda.call;

	final public class PacketRouter
	{
		private const requestDict:Object = new Dictionary();
		private const noticeDict:Object = new Dictionary();
		
		public function PacketRouter()
		{
		}
		
		public function hasRequestHandler(msgId:uint):Boolean
		{
			return hasKey(requestDict, msgId);
		}
		
		public function hasNoticeHandler(msgId:uint):Boolean
		{
			return hasKey(noticeDict, msgId);
		}
		
		public function regRequestHandler(packet:IPacket, callback:Object):void
		{
			var trait:PacketTrait = new PacketTrait(packet, callback, getTimer());
			if(hasRequestHandler(packet.msgId)){
				var list:Array = requestDict[packet.msgId];
				list.push(trait);
			}else{
				requestDict[packet.msgId] = [trait];
			}
		}
		
		public function regNoticeHandler(msgId:uint, handler:Object):void
		{
			if(hasNoticeHandler(msgId)){
				throw new Error("msgId has been registered yet!");
			}
			noticeDict[msgId] = handler;
		}
		
		public function routeResponse(packet:IPacket):void
		{
			var list:Array = requestDict[packet.msgId];
			var trait:PacketTrait = list.shift();
			lambda.call(trait.callback, true, packet.msgData);
		}
		
		public function routeNotice(packet:IPacket):void
		{
			var handler:Object = noticeDict[packet.msgId];
			if(null == handler){
				throw new Error("msgId has not been registered yet!");
			}
			lambda.call(handler, packet.msgData);
		}
		
		public function checkTimeout():void
		{
			var now:int = getTimer();
			for each(var list:Array in requestDict){
				for each(var trait:PacketTrait in list){
					if(now - trait.timestamp < 10000){
						continue;
					}
					lambda.call(trait.callback, false, "request timeout!");
				}
			}
		}
	}
}