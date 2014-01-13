package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.Expression;
	import snjdck.arithmetic.impl.StatementBlock;
	
	public class IfStatement implements IExecutable
	{
		private var condition:Expression;
		private var trueBlock:StatementBlock;
		private var falseBlock:IExecutable;
		
		public function IfStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			if(condition.calculate(context)){
				trueBlock.calculate(context);
			}else if(falseBlock){
				falseBlock.calculate(context);
			}
		}
	}
}