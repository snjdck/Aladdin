package flash.mvc.kernel
{
	import flash.mvc.notification.Msg;

	public interface ICommand extends INotifier
	{
		function exec(msg:Msg):void;
	}
}