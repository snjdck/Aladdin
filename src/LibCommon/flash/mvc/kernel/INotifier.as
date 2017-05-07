package flash.mvc.kernel
{
	[ExcludeClass]
	public interface INotifier
	{
		/**
		 * @return Boolean -- 如果成功调度了事件，则值为 true。 值 false 表示失败或对事件调用了 preventDefault();
		 */
		function notify(msgName:Object, msgData:Object=null):Boolean;
	}
}