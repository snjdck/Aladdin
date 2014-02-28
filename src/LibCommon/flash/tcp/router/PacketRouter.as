package flash.tcp.router
{
	import dict.hasKey;
	
	import flash.tcp.IPacket;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import lambda.call;

	final public class PacketRouter
	{
		private const handlerDict:Object = new Dictionary();
		
		public function PacketRouter()
		{
		}
		
		public function hasHandler(msgId:uint):Boolean
		{
			return hasKey(handlerDict, msgId);
		}
		
		public function regRequest(packet:IPacket, callback:Object):void
		{
			var trait:PacketTrait = new PacketTrait(packet, callback, getTimer());
			if(hasHandler(packet.msgId)){
				var list:Array = handlerDict[packet.msgId];
				list.push(trait);
			}else{
				handlerDict[packet.msgId] = [trait];
			}
		}
		
		public function route(packet:IPacket):void
		{
			var list:Array = handlerDict[packet.msgId];
			var trait:PacketTrait = list.shift();
			lambda.call(trait.callback, true, packet.msgData);
		}
		
		public function checkTimeout():void
		{
			var now:int = getTimer();
			for each(var list:Array in handlerDict){
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