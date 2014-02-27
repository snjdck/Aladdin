package snjdck.mvc
{
	import dict.hasKey;
	
	import snjdck.injector.IInjector;
	import snjdck.injector.Injector;
	import snjdck.mvc.core.IApplication;
	import snjdck.mvc.helper.ServiceInitializer;
	import snjdck.mvc.helper.ServiceRegInfo;
	
	import flash.reflection.getTypeName;
	
	use namespace ns_mvc;

	public class Application implements IApplication
	{
		static public const MSG_START_UP:MsgName = new MsgName();
		static public const MSG_SHUT_DOWM:MsgName = new MsgName();
		
		static private var instance:Application;
		
		static public function GetInstance():Application
		{
			return instance;
		}
		
		private const injector:IInjector = new Injector();
		private const moduleDict:Object = {};
		private var hasStartup:Boolean;
		
		public function Application()
		{
			checkSingleton();
			injector.mapValue(Application, this, null, false);
		}
		
		private function checkSingleton():void
		{
			if(instance){
				throw new Error("Application must be singleton!");
			}else{
				instance = this;
			}
		}
		
		public function regModule(module:Module):void
		{
			module.bindToApplication(this);
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
		
		private const serviceInitializer:ServiceInitializer = new ServiceInitializer();
		
		public function regService(serviceInterface:Class, serviceClass:Class, moduleInjector:IInjector=null):void
		{
			var serviceRegInfo:ServiceRegInfo = new ServiceRegInfo(serviceInterface, serviceClass, moduleInjector || injector);
			if(hasStartup){
				serviceRegInfo.regService(injector);
			}else{
				serviceInitializer.regService(serviceRegInfo);
			}
		}
		
		public function getInjector():IInjector
		{
			return injector;
		}
		
		/*
		public function notifyAll(msgName:MsgName, msgData:Object):Boolean
		{
			var msg:Msg = new Msg(msgName, msgData, null);
			for each(var module:Module in moduleDict){
				module.notifyImp(msg);
				if(msg.isProcessCanceled()){
					break;
				}
			}
			return !msg.isDefaultPrevented();
		}
		*/
		public function startup():void
		{
			if(!hasStartup){
				onStartup();
				hasStartup = true;
//				notifyAll(MSG_START_UP, null);
			}
		}
		
		public function shutdown():void
		{
			if(hasStartup){
				hasStartup = false;
				onShutdown();
//				notifyAll(MSG_SHUT_DOWM, null);
			}
		}
		
		private function onStartup():void
		{
			initAllModuleModels();
			initAllModuleServices();
			initAllModuleViews();
			initAllModuleControllers();
		}
		
		private function onShutdown():void
		{
		}
		/*
		public function getModuleByName(moduleName:String):Module
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function regModuleByName(moduleName:String, module:Module):void
		{
			// TODO Auto Generated method stub
			
		}
		*/
		public function initAllModuleModels():void
		{
			for each(var module:Module in moduleDict){
				module.initAllModels();
			}
		}
		
		public function initAllModuleServices():void
		{
			for each(var module:Module in moduleDict){
				module.initAllServices();
			}
			serviceInitializer.initialize(injector);
		}
		
		public function initAllModuleViews():void
		{
			for each(var module:Module in moduleDict){
				module.initAllViews();
			}
		}
		
		public function initAllModuleControllers():void
		{
			for each(var module:Module in moduleDict){
				module.initAllControllers();
			}
		}
	}
}