package flash.mvc.controller
{
	import flash.display.DisplayObjectContainer;
	import flash.mvc.Module;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	import flash.mvc.kernel.INotifier;
	import flash.mvc.ns_mvc;
	
	use namespace ns_mvc;

	public class Command implements INotifier
	{
		[Inject]
		public var module:Module;
		
		[Inject]
		public var msg:Msg;
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		public function Command()
		{
		}
		
		public function exec():void
		{
		}
		
		final public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return module.notifyImp(new Msg(msgName, msgData, this));
		}
	}
}