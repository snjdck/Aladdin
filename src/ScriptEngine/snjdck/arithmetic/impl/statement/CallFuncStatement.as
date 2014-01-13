package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.Expression;
	import snjdck.arithmetic.impl.FuncDef;
	
	public class CallFuncStatement implements IExecutable
	{
		public var funcRef:FuncDef;
		public var argExpressionList:Vector.<Expression>;
		
		public function CallFuncStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			var argList:Array = [];
			for(var i:int=0; i<argExpressionList.length; i++){
				argList[i] = argExpressionList[i].calculate(context);
			}
			return funcRef.exec(context, argList);
		}
	}
}