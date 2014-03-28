package flash.mvc.service
{
	import flash.ioc.IInjector;

	final public class ServiceRegInfo
	{
		public var serviceInterface:Class;
		public var serviceClass:Class;
		public var moduleInjector:IInjector;
		
		private var typesNeedToBeInjected:Array;
		
		public function ServiceRegInfo(serviceInterface:Class, serviceClass:Class, moduleInjector:IInjector)
		{
			this.serviceInterface = serviceInterface;
			this.serviceClass = serviceClass;
			this.moduleInjector = moduleInjector;
			this.typesNeedToBeInjected = moduleInjector.getTypesNeedInject(serviceClass);
		}
		
		public function getTypesNeedToBeInjected():Array
		{
			return typesNeedToBeInjected;
		}
		
		public function regService(appInjector:IInjector):void
		{
			var service:Object = moduleInjector.newInstance(serviceClass);
			appInjector.mapValue(serviceInterface, service, null, false);
		}
	}
}