package snjdck.ai.statemachine
{
	public class StateMachine
	{
		private var globalState:State;
		private var currentState:State;
		
		public function StateMachine()
		{
		}
		
		public function switchState(newState:State):void
		{
			if(currentState){
				currentState.onExit();
			}
			
			currentState = newState;
			
			if(currentState){
				currentState.onEnter();
			}
		}
		
		public function onUpdate():void
		{
			globalState.onUpdate();
			currentState.onUpdate();
		}
	}
}