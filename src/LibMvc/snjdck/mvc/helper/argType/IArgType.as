package snjdck.mvc.helper.argType
{
	import snjdck.mvc.Msg;

	[ExcludeClass]
	public interface IArgType
	{
		function exec(handler:Function, msg:Msg):void;
	}
}