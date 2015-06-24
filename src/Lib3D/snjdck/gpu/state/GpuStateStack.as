package snjdck.gpu.state
{
	import snjdck.gpu.asset.GpuContext;

	public class GpuStateStack
	{
		private var stateStack:Vector.<GpuState> = new Vector.<GpuState>();
		private var stateIndex:int = -1;
		private var context3d:GpuContext;
		
		public function GpuStateStack(context3d:GpuContext)
		{
			this.context3d = context3d;
		}
		
		public function save():void
		{
			++stateIndex;
			if(stateStack.length <= stateIndex){
				stateStack.push(new GpuState());
			}
			gpuState.copyFrom(context3d);
		}
		
		public function restore():void
		{
			gpuState.applyTo(context3d);
			gpuState.clear();
			--stateIndex;
		}
		
		private function get gpuState():GpuState
		{
			return stateStack[stateIndex];
		}
	}
}