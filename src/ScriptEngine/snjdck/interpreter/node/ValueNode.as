package snjdck.interpreter.node
{
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.IScriptContext;

	public class ValueNode implements IExecutable
	{
		private var value:Object;
		
		public function ValueNode(value:Object)
		{
			this.value = value;
		}
		
		public function calculate(context:IScriptContext):*
		{
			return value;
		}
	}
}