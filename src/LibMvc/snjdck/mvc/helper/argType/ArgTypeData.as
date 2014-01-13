package snjdck.mvc.helper.argType
{
	import snjdck.mvc.Msg;

	internal class ArgTypeData implements IArgType
	{
		public function exec(handler:Function, msg:Msg):void
		{
			handler(msg.data);
		}
	}
}