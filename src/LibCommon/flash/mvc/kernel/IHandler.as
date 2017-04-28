package flash.mvc.kernel
{
	import flash.mvc.notification.Msg;

	[ExcludeClass]
	public interface IHandler
	{
		function handleMsg(msg:Msg):void;
	}
}