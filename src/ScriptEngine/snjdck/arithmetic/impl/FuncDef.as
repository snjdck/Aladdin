package snjdck.arithmetic.impl
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	
	public class FuncDef
	{
		private var paramList:Vector.<String>;
		public var funcBody:StatementBlock;
		
		public function FuncDef()
		{
			paramList = new Vector.<String>();
		}
		
		public function addParam(paramIndex:int, paramName:String):void
		{
			paramList[paramIndex] = paramName;
		}
		
		public function exec(context:IScriptContext, argList:Array):*
		{
			context = context.createChildContext();
			initArgs(context, argList);
			var result:Object = funcBody.calculate(context);
			return result;
		}
		
		private function initArgs(context:IScriptContext, argList:Array):void
		{
			for(var paramIndex:int=0; paramIndex<paramList.length; paramIndex++){
				context.setValue(paramList[paramIndex], argList[paramIndex]);
			}
		}
	}
}