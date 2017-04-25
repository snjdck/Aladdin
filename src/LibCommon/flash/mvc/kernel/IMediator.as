package flash.mvc.kernel
{
	import flash.mvc.notification.Msg;

	public interface IMediator
	{
		function handleMsg(msg:Msg):void;
	}
}