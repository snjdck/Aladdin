package flash.mvc
{
	import flash.ioc.Injector;
	import flash.utils.getQualifiedClassName;
	
	public class Application
	{
		protected const injector:Injector = new Injector();
		private const moduleDict:Object = {};
		private var hasStartup:Boolean;
		
		public function Application()
		{
			injector.mapValue(Application, this, null, false);
			injector.mapValue(Injector, injector, null, false);
		}
		
		public function regModule(module:Module):void
		{
			var moduleName:String = getQualifiedClassName(module);
			if(moduleName in moduleDict)
				throw new ArgumentError(moduleName + " has registered yet!");
			moduleDict[moduleName] = module;
			module.applicationInjector = injector;
			
			if(hasStartup)
			{
				module.initAllModels();
				module.initAllServices();
				module.initAllViews();
				module.initAllControllers();
				module.onStartup();
			}
		}
		
		public function startup():void
		{
			if(!hasStartup){
				hasStartup = true;
				onStartup();
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
			for each(module in moduleDict){
				module.initAllViews();
			}
			for each(module in moduleDict){
				module.initAllControllers();
			}
			for each(module in moduleDict){
				module.onStartup();
			}
		}
	}
}