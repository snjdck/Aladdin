package snjdck.tesla.kernel.services.support
{
	import flash.mvc.Module;
	
	public class Service
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