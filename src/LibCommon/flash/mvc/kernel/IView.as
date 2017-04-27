package flash.mvc.kernel
{
	import flash.mvc.notification.Msg;

	public interface IView
	{
		function handleMsg(msg:Msg):void;
	}
}