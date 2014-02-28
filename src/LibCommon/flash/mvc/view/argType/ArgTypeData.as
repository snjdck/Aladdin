package flash.mvc.view.argType
{
	import flash.mvc.notification.Msg;

	internal class ArgTypeData implements IArgType
	{
		public function exec(handler:Function, msg:Msg):void
		{
			handler(msg.data);
		}
	}
}