package snjdck.arithmetic.impl
{
	import lambda.apply;
	
	import snjdck.arithmetic.IScriptContext;
	
	import stdlib.reflection.getType;

	public class ScriptContextFactory
	{
		static public function CreateScriptContext():IScriptContext
		{
			var context:IScriptContext = new ScriptContext();
			context.newKey("true",	true);
			context.newKey("false",	false);
			context.newKey("null",	null);
			context.newKey("trace",	trace);
			context.newKey("type",	getType);
			context.newKey("new",	apply);
			return context;
		}
	}
}