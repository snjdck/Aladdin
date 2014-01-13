package snjdck.interpreter.node
{
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.IScriptContext;
	import snjdck.interpreter.FuncData;
	
	public class FuncNode implements IExecutable
	{
		private var funcData:FuncData;
		private var funcArgs:Array;
		
		public function FuncNode(funcData:FuncData, funcArgs:Array)
		{
			this.funcData = funcData;
			this.funcArgs = funcArgs;
		}
		
		public function calculate(context:IScriptContext):*
		{
			return funcData.exec(funcArgs, context);
		}
		
	}
}