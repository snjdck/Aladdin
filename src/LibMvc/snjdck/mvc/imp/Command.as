package snjdck.mvc.imp
{
	import flash.display.DisplayObjectContainer;
	
	import snjdck.mvc.Module;
	import snjdck.mvc.Msg;
	import snjdck.mvc.MsgName;
	import snjdck.mvc.core.INotifier;
	import snjdck.mvc.ns_mvc;
	import snjdck.mvc.helper.argType.IArgType;
	
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
		
		final protected function execImp(handler:Function, argType:IArgType):void
		{
			argType.exec(handler, msg);
		}
	}
}