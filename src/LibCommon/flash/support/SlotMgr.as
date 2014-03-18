package flash.support
{
	import flash.utils.Dictionary;

	public class SlotMgr
	{
		private var slotDict:Object;
		private var objDict:Object;
		
		public function SlotMgr()
		{
			slotDict = new Dictionary();
			objDict = new Dictionary();
		}
		
		public function regSlot(key:*, initVal:int=0):void
		{
			if(key in slotDict){
				throw new Error("key is exist!");
			}
			slotDict[key] = initVal;
		}
		
		public function getBestSlot():*
		{
			var minKey:* = null;
			var minVal:int = int.MAX_VALUE;
			for(var key:* in slotDict){
				var val:int = slotDict[key];
				if(minVal >= val){
					minKey = key;
					minVal = val;
				}
			}
			return minKey;
		}
		
		public function useSlot(key:*):void
		{
			if(key in slotDict == false){
				throw new Error("key is not exist!");
			}
			++slotDict[key];
		}
		
		public function freeSlot(key:*):void
		{
			if(key in slotDict == false){
				throw new Error("key is not exist!");
			}
			--slotDict[key];
		}
		
		public function addObj(obj:Object):*
		{
			var bestSlot:* = getBestSlot();
			useSlot(bestSlot);
			objDict[obj] = bestSlot;
			return bestSlot;
		}
		
		public function delObj(obj:Object):*
		{
			var bestSlot:* = objDict[obj];
			freeSlot(bestSlot);
			delete objDict[obj];
			return bestSlot;
		}
	}
}