package flash.mvc.view.argType
{
	import flash.mvc.notification.Msg;

	internal class ArgTypeDefault implements IArgType
	{
		public function exec(handler:Function, msg:Msg):void
		{
			switch(handler.length){
				case 0:
					handler();
					break;
				case 2:
					handler(msg, msg.data);
					break;
				default:
					handler(msg);
			}
		}
	}
}