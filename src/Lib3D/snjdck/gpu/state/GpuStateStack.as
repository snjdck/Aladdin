package snjdck.gpu.state
{
	import snjdck.gpu.asset.GpuContext;

	public class GpuStateStack
	{
		private var stateStack:Vector.<GpuState> = new Vector.<GpuState>();
		private var stateIndex:int = -1;
		
		public function GpuStateStack(){}
		
		public function save(context3d:GpuContext):void
		{
			++stateIndex;
			if(stateStack.length <= stateIndex){
				stateStack.push(new GpuState());
			}
			gpuState.copyFrom(context3d);
		}
		
		public function restore(context3d:GpuContext):void
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