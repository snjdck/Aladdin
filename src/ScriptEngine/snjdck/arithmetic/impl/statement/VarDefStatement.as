package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.Expression;
	
	public class VarDefStatement implements IExecutable
	{
		public var varName:String;
		public var expression:Expression;
		
		public function VarDefStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			var varValue:Object = expression && expression.calculate(context);
			context.setValue(varName, varValue);
		}
	}
}