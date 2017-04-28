package flash.ioc.ip
{
	import flash.ioc.IInjectionPoint;
	import flash.ioc.IInjector;
	import flash.utils.getDefinitionByName;

	internal class InjectionPointProperty implements IInjectionPoint
	{
		private var name:String;
		private var info:Object;
		private var argType:Class;
		
		public function InjectionPointProperty(name:String, info:Object, argType:String)
		{
			this.name = name;
			this.info = info;
			this.argType = getDefinitionByName(argType) as Class;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var val:Object = injector.getInstance(argType, info[0]);
			if(null != val){
				target[name] = val;
			}
		}
	}
}