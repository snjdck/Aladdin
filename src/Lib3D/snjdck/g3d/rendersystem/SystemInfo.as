package snjdck.g3d.rendersystem
{
	import snjdck.gpu.asset.GpuContext;

	internal class SystemInfo
	{
		internal var priority:int;
		private var system:ISystem;
		private const itemList:Array = [];
		private var itemCount:int;
		
		public function SystemInfo(system:ISystem, priority:int)
		{
			this.system = system;
			this.priority = priority;
		}
		
		public function addItem(item:Object):void
		{
			if(itemList.indexOf(item) < 0){
				itemList[itemCount] = item;
				++itemCount;
			}
		}
		
		public function render(context3d:GpuContext):void
		{
			if(itemCount <= 0){
				return;
			}
			system.onDrawBegin(context3d);
			for(var i:int=0; i<itemCount; ++i){
				system.render(context3d, itemList[i]);
			}
			itemList.length = itemCount = 0;
		}
	}
}