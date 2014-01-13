package snjdck.arithmetic
{
	public interface IExpression extends IExecutable
	{
		function assign(context:IScriptContext, value:Object):void;
	}
}