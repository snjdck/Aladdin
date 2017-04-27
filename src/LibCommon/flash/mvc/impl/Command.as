package flash.mvc.impl
{
	import flash.mvc.kernel.ICommand;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	import flash.mvc.Module;
	
	public class Command implements ICommand
	{
		[Inject]
		public var module:Module;
		
		public function Command(){}
		
		public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return module.notify(msgName, msgData);
		}
		
		public function exec(msg:Msg):void
		{
		}
	}
}