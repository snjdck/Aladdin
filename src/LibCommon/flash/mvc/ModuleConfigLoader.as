package flash.mvc
{
	import flash.reflection.getType;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import lambda.apply;
	
	import flash.http.loadMedia;
	
	import flash.support.Http;
	
	import string.trim;

	public class ModuleConfigLoader
	{
		private var moduleCount:int;
		private var isLoading:Boolean;
		
		public function ModuleConfigLoader()
		{
		}
		
		/**
		 * @see #loadXml
		 */
		public function load(configPath:String, application:Application, callback:Object=null):void
		{
			assert(!isLoading, "is loading module config!");
			isLoading = true;
			
			Http.Get(configPath, null, [__onConfigLoad, application, callback]);
		}
		
		private function __onConfigLoad(ok:Boolean, data:*, application:Application, callback:Object):void
		{
			assert(ok, "module config load failed!" + data);
			isLoading = false;
			
			loadXml(XML(data.toString()), application, callback);
		}
		
		/**
		 * if null == callback, application.startup() will be called when all modules loaded.
		 */
		public function loadXml(config:XML, application:Application, callback:Object=null):void
		{
			assert(!isLoading, "is loading module!");
			isLoading = true;
			
			var elementList:XMLList = config.children();
			moduleCount = elementList.length();
			for each(var element:XML in elementList)
			{
				var path:String = element.attribute("path");
				var entry:String = element.attribute("entry");
				loadMedia(path, [__onDllLoad, entry.split(","), application, callback], null, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
		}
		
		private function __onDllLoad(ok:Boolean, data:*, entryList:Array, application:Application, callback:Object):void
		{
			assert(ok, "module load failed!" + data);
			isLoading = false;
			
			for each(var entry:String in entryList)
			{
				var moduleCls:Class = getType(trim(entry));
				var module:Module = new moduleCls();
				application.regModule(module);
			}
			
			moduleCount--;
			checkIsAllLoaded(application, callback);
		}
		
		private function checkIsAllLoaded(application:Application, callback:Object):void
		{
			if(moduleCount > 0){
				return;
			}
			if(null != callback){
				lambda.apply(callback);
			}else{
				application.startup();
			}
		}
	}
}