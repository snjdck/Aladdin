package flash.mvc.kernel
{
	import flash.mvc.notification.MsgName;

	[ExcludeClass]
	public interface INotifier
	{
		/**
		 * @return Boolean -- 如果成功调度了事件，则值为 true。 值 false 表示失败或对事件调用了 preventDefault();
		 */
		function notify(msgName:MsgName, msgData:Object=null):Boolean;
	}
}