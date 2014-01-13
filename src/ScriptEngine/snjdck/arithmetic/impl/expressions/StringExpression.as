package snjdck.arithmetic.impl.expressions
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.impl.Expression;
	
	public class StringExpression extends Expression
	{
		public function StringExpression()
		{
			super();
		}
		
		override public function calculate(context:IScriptContext):*
		{
			return rawData;
		}
	}
}