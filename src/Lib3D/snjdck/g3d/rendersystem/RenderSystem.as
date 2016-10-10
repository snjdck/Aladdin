package snjdck.g3d.rendersystem
{
	import snjdck.gpu.asset.GpuContext;

	public class RenderSystem
	{
		private const priorityDict:Array = [];
		private const systemList:Array = [];
		private var systemCount:int;
		
		public function RenderSystem()
		{
		}
		
		public function render(context3d:GpuContext, passIndex:int):void
		{
			for(var i:int=0; i<systemCount; ++i){
				var info:SystemInfo = systemList[i];
				info.render(context3d, passIndex);
			}
		}
		
		public function regSystem(system:ISystem, priority:int):void
		{
			var info:SystemInfo = new SystemInfo(system, priority);
			var needInsert:Boolean = true;
			for(var i:int=0; i<systemCount; ++i){
				var testItem:SystemInfo = systemList[i];
				if(priority > testItem.priority){
					systemList.insertAt(i, info);
					needInsert = false;
					break;
				}
			}
			if(needInsert){
				systemList.push(info);
			}
			priorityDict[priority] = info;
			++systemCount;
		}
		
		public function addItem(item:Object, priority:int):void
		{
			var info:SystemInfo = priorityDict[priority];
			assert(info != null);
			info.addItem(item);
		}
	}
}