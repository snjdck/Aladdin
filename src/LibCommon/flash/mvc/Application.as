package flash.mvc
{
	import flash.ioc.IInjector;
	import flash.ioc.Injector;
	//import flash.mvc.service.ServiceInitializer;
	import flash.mvc.service.ServiceRegInfo;
	import flash.reflection.getTypeName;
	
	import dict.hasKey;
	
	use namespace ns_mvc;

	public class Application
	{
		private const injector:IInjector = new Injector();
		private const moduleDict:Object = {};
		//private var serviceInitializer:ServiceInitializer;
		private var hasStartup:Boolean;
		
		public function Application()
		{
			//serviceInitializer = new ServiceInitializer();
			injector.mapValue(Application, this, null, false);
			injector.mapValue(IInjector, injector, null, false);
		}
		
		public function regModule(module:Module):void
		{
			module.onRegisted(this);
			injector.injectInto(module);
			var moduleName:String = getTypeName(module, true);
			
			if(hasKey(moduleDict, moduleName)){
				throw new ArgumentError(moduleName + " has registered yet!");
			}else{
				moduleDict[moduleName] = module;
			}
			
			if(hasStartup)
			{
				module.initAllModels();
				module.initAllServices();
				module.initAllViews();
				module.initAllControllers();
			}
		}
		
		public function regService(serviceInterface:Class, serviceClass:Class, moduleInjector:IInjector=null):void
		{
			var serviceRegInfo:ServiceRegInfo = new ServiceRegInfo(serviceInterface, serviceClass, moduleInjector || injector);
			if(hasStartup){
				serviceRegInfo.regService(injector);
			}else{
				//serviceInitializer.regService(serviceRegInfo);
				injector.mapSingleton(serviceInterface, serviceClass, null, moduleInjector);
			}
		}
		
		public function getInjector():IInjector
		{
			return injector;
		}
		
		public function startup():void
		{
			if(false == hasStartup){
				onStartup();
				hasStartup = true;
			}
		}
		
		private function onStartup():void
		{
			var module:Module;
			for each(module in moduleDict){
				module.initAllModels();
			}
			for each(module in moduleDict){
				module.initAllServices();
			}
			//serviceInitializer.initialize(injector);
			for each(module in moduleDict){
				module.initAllViews();
			}
			for each(module in moduleDict){
				module.initAllControllers();
			}
			//serviceInitializer = null;
			for each(module in moduleDict){
				module.onStartup();
			}
		}
	}
}