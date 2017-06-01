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
			
			if(hasStartup){
				doStartup([module]);
			}
		}
		
		public function startup():void
		{
			if(!hasStartup){
				hasStartup = true;
				doStartup(moduleDict);
			}
		}
		
		private function doStartup(moduleList:Object):void
		{
			var module:Module;
			for each (module in moduleList) module.initAllModels();
			for each (module in moduleList) module.initAllServices();
			for each (module in moduleList) module.initAllViews();
			for each (module in moduleList) module.initAllControllers();
			for each (module in moduleList) module.onStartup();
		}
	}
}