package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.Expression;
	import snjdck.arithmetic.impl.StatementBlock;
	
	public class WhileStatement implements IExecutable
	{
		private var condition:Expression;
		private var block:StatementBlock;
		
		public function WhileStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			while(condition.calculate(context)){
				block.calculate(context);
			}
		}
	}
}