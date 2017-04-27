package flash.mvc.impl
{
	import flash.mvc.kernel.IModel;
	import flash.mvc.notification.MsgName;
	import flash.mvc.Module;
	
	public class Model implements IModel
	{
		[Inject]
		public var module:Module;
		
		public function Model(){}
		
		public function notify(msgName:MsgName, msgData:Object=null):Boolean
		{
			return module.notify(msgName, msgData);
		}
	}
}