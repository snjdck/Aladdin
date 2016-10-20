package snjdck.g3d.rendersystem
{
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.asset.GpuContext;

	internal class SystemInfo
	{
		internal var priority:int;
		private var system:ISystem;
		private const itemList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		private var itemCount:int;
		
		public function SystemInfo(system:ISystem, priority:int)
		{
			this.system = system;
			this.priority = priority;
		}
		
		public function addItem(item:IDrawUnit3D):void
		{
			if(itemList.indexOf(item) < 0){
				itemList[itemCount] = item;
				++itemCount;
			}
		}
		
		public function clear():void
		{
			itemList.length = itemCount = 0;
		}
		
		public function render(context3d:GpuContext, renderType:int, tagFilter:uint):void
		{
			if(!needRender(tagFilter)){
				return;
			}
			system.activePass(context3d, renderType);
			for(var i:int=0; i<itemCount; ++i){
				var item:IDrawUnit3D = itemList[i];
//				if(item.tag == tagFilter){
				if((item.tag & tagFilter) == tagFilter){
					system.render(context3d, item);
				}
			}
		}
		
		private function needRender(tagFilter:uint):Boolean
		{
			for(var i:int=0; i<itemCount; ++i){
				var item:IDrawUnit3D = itemList[i];
//				if(item.tag == tagFilter){
				if((item.tag & tagFilter) == tagFilter){
					return true;
				}
			}
			return false;
		}
	}
}