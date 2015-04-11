package flash.mvc.service
{
	import flash.ioc.IInjector;
	import flash.ioc.ip.InjectionPoint;

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
			//this.typesNeedToBeInjected = InjectionPoint.GetTypesNeedInject(serviceClass);
		}
		
		public function getTypesNeedToBeInjected():Array
		{
			return typesNeedToBeInjected;
		}
		
		public function regService(appInjector:IInjector):void
		{
			var service:Object = new serviceClass();
			moduleInjector.injectInto(service);
			appInjector.mapValue(serviceInterface, service, null, false);
		}
	}
}