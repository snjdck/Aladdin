package flash.mvc.impl
{
	import flash.mvc.Module;
	import flash.mvc.kernel.IModel;
	
	public class Model implements IModel
	{
		[Inject]
		public var module:Module;
		
		public function Model(){}
		
		public function notify(msgName:Object, msgData:Object=null):Boolean
		{
			return module.notify(msgName, msgData);
		}
	}
}