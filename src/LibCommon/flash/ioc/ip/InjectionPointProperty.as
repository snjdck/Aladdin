package flash.ioc.ip
{
	import array.push;
	
	import flash.ioc.IInjector;

	final internal class InjectionPointProperty extends InjectionPoint implements IInjectionPoint
	{
		private var argType:String;
		
		public function InjectionPointProperty(name:String, info:Object, argType:String)
		{
			super(name, info);
			this.argType = argType;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var val:Object = injector.getInstance(argType, info[0]);
			if(null != val){
				target[name] = val;
			}
		}
		
		public function get priority():int
		{
			return 1;
		}
		
		public function getTypesNeedToBeInjected(result:Array):void
		{
			array.push(result, argType);
		}
	}
}