package snjdck.arithmetic.impl.statement
{
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.IExecutable;
	import snjdck.arithmetic.impl.FuncDef;
	import snjdck.arithmetic.impl.StatementBlock;
	
	public class FuncDefStatement implements IExecutable
	{
		private var funcName:String;
		private var funcInfo:FuncDef;
		
		public function FuncDefStatement()
		{
		}
		
		public function calculate(context:IScriptContext):*
		{
			if(funcName){
				context.setValue(funcName, funcInfo);
			}
			return funcInfo;
		}
	}
}