package snjdck.arithmetic.impl.expressions
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.impl.Expression;
	
	public class DotExpression extends Expression
	{
		public function DotExpression()
		{
			super();
		}
		
		override public function assign(context:IScriptContext, value:Object):void
		{
			var target:Object = left.calculate(context);
			var key:String = right.calculate(context);
			target[key] = value;
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var target:Object = left.calculate(context);
			var key:String = right.calculate(context);
			return target[key];
		}
	}
}