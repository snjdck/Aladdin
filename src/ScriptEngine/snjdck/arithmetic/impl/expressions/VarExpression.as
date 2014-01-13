package snjdck.arithmetic.impl.expressions
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.impl.Expression;
	
	public class VarExpression extends Expression
	{
		public function VarExpression()
		{
			super();
		}
		
		override public function assign(context:IScriptContext, value:Object):void
		{
			context.setValue(rawData, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			return context.getValue(rawData);
		}
		
	}
}