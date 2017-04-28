package flash.mvc.impl
{
	import flash.mvc.Module;
	import flash.mvc.kernel.IController;
	import flash.mvc.notification.Msg;
	import flash.mvc.notification.MsgName;
	import flash.utils.Dictionary;
	
	public class Controller implements IController
	{
		[Inject]
		public var module:Module;
		
		private const handlerDict:Object = new Dictionary();
		
		public function Controller(){}
		
		public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return module.notify(msgName, msgData);
		}
		
		public function handleMsg(msg:Msg):void
		{
			var handler:Function = handlerDict[msg.name];
			if(handler == null)
				return;
			handler(msg);
		}
		
		public function regHandler(msgName:MsgName, handler:Function):void
		{
			handlerDict[msgName] = handler;
		}
	}
}