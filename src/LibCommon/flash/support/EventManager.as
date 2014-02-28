package flash.support
{
	import flash.events.IEventDispatcher;

	final public class EventManager
	{
		private var evtInfoList:Vector.<Array>;
		
		public function EventManager()
		{
			evtInfoList = new Vector.<Array>();
		}
		
		public function addEvt(target:IEventDispatcher, evtType:String, listener:Function):void
		{
			if(!hasEvtInfo(arguments)){
				target.addEventListener(evtType, listener);
				addEvtInfo(arguments);
			}
		}
		
		public function delEvt(target:IEventDispatcher, evtType:String, listener:Function):void
		{
			if(hasEvtInfo(arguments)){
				target.removeEventListener(evtType, listener);
				removeEvtInfo(arguments);
			}
		}
		
		public function delAllEvts():void
		{
			while(evtInfoList.length > 0){
				removeEventListener.apply(null, evtInfoList.pop());
			}
		}
		
		public function delEvtsOf(target:IEventDispatcher):void
		{
			var index:int = evtInfoList.length;
			while(index-- > 0){
				if(evtInfoList[index][0] == target){
					removeEvtInfoAt(index);
				}
			}
		}
		
		private function removeEventListener(target:IEventDispatcher, evtType:String, listener:Function):void
		{
			target.removeEventListener(evtType, listener);
		}
		
		private function addEvtInfo(evtInfo:Array):void
		{
			evtInfoList[evtInfoList.length] = evtInfo;
		}
		
		private function removeEvtInfo(evtInfo:Array):void
		{
			for(var index:* in evtInfoList){
				if(isEvtInfoEqual(evtInfoList[index], evtInfo)){
					removeEvtInfoAt(index);
					return;
				}
			}
		}
		
		private function hasEvtInfo(evtInfo:Array):Boolean
		{
			for each(var info:Array in evtInfoList){
				if(isEvtInfoEqual(info, evtInfo)){
					return true;
				}
			}
			return false;
		}
		
		private function isEvtInfoEqual(va:Array, vb:Array):Boolean
		{
			return (va[0] == vb[0]) && (va[1] == vb[1]) && (va[2] == vb[2]);
		}
		
		private function removeEvtInfoAt(index:int):void
		{
			evtInfoList.splice(index, 1);
		}
	}
}