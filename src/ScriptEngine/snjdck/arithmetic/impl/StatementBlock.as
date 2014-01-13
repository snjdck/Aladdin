package snjdck.arithmetic.impl
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.ReturnError;
	
	public class StatementBlock implements IExecutable
	{
		private var statementList:Vector.<IExecutable>;
		
		public function StatementBlock()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			for each(var statement:IExecutable in statementList){
				try{
					statement.calculate(context);
				}catch(returnError:ReturnError){
					return returnError.value;
				}
			}
		}
	}
}