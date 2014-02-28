package flash.mvc.view.argType
{
	import flash.mvc.notification.Msg;

	[ExcludeClass]
	public interface IArgType
	{
		function exec(handler:Function, msg:Msg):void;
	}
}