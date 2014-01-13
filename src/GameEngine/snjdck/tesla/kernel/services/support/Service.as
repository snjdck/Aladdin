package snjdck.tesla.kernel.services.support
{
	import snjdck.mvc.Module;
	import snjdck.mvc.core.IService;
	
	public class Service implements IService
	{
		[Inject]
		public var module:Module;
		
		public function Service()
		{
		}
		
		public function isAvailable():Boolean
		{
			return true;
		}
	}
}