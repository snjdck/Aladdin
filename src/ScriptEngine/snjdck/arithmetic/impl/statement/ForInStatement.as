package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.Expression;
	import snjdck.arithmetic.impl.StatementBlock;
	
	public class ForInStatement implements IExecutable
	{
		private var varName:String;
		private var forTarget:Expression;
		private var block:StatementBlock;
		
		public function ForInStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			var target:Object = forTarget.calculate(context);
			for(var key:String in target){
				context.setValue(varName, key);
				block.calculate(context);
			}
		}
	}
}