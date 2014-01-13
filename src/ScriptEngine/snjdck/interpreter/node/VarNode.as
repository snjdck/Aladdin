package snjdck.interpreter.node
{
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.IScriptContext;

	public class VarNode implements IExecutable
	{
		private var varName:String;
		
		public function VarNode(varName:String)
		{
			this.varName = varName;
		}
		
		public function calculate(context:IScriptContext):*
		{
			return context.getValue(varName);
		}
		
	}
}