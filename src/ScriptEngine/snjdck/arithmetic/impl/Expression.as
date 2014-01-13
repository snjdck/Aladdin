package snjdck.arithmetic.impl
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.IExpression;

	public class Expression implements IExpression
	{
		public var left:Expression;
		public var right:Expression;
		public var rawData:String;
		
		public function Expression()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			throw "need override!";
		}
		
		public function assign(context:IScriptContext, value:Object):void
		{
			throw "need override!";
		}
	}
}