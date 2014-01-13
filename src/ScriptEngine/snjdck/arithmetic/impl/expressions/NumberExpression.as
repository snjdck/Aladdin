package snjdck.arithmetic.impl.expressions
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.impl.Expression;
	
	public class NumberExpression extends Expression
	{
		private var value:Number;
		
		public function NumberExpression()
		{
			super();
			value = parseFloat(rawData);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			return value;
		}
	}
}