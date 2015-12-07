package snjdck.gpu.state
{
	final public class StateStack
	{
		private const stateStack:Array = [];
		private var stateIndex:int;
		private var stateCls:Class;
		
		public function StateStack(stateCls:Class)
		{
			this.stateCls = stateCls;
			this.stateIndex = -1;
		}
		
		public function get count():int
		{
			return stateIndex + 1;
		}
		
		public function push():void
		{
			++stateIndex;
			if(stateStack.length <= stateIndex){
				stateStack.push(new stateCls());
			}
		}
		
		public function pop():void
		{
			--stateIndex;
		}
		
		public function get state():*
		{
			if(stateIndex < 0){
				return null;
			}
			return stateStack[stateIndex];
		}
		
		public function get prevState():*
		{
			if(stateIndex > 0){
				return stateStack[stateIndex-1];
			}
			return null;
		}
	}
}