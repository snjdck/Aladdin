package snjdck.gpu.asset
{
	import flash.utils.Dictionary;

	internal class AssetGC
	{
		private var prevList:Object;
		private var currList:Object;
		
		public function AssetGC()
		{
			prevList = new Dictionary(true);
			currList = new Dictionary(true);
		}
		
		public function addRef(item:IGpuAsset):void
		{
			currList[item] = null;
			delete prevList[item];
		}
		
		public function gc():void
		{
			for(var key:* in prevList){
				delete prevList[key];
				var item:IGpuAsset = key;
				item.freeGpuMemory();
			}
			var tempList:Object = prevList;
			prevList = currList;
			currList = tempList;
		}
	}
}