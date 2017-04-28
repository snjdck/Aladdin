package flash.ioc.ip
{
	import flash.ioc.IInjectionPoint;
	import flash.ioc.IInjector;
	import flash.utils.getDefinitionByName;

	internal class InjectionPointMethod implements IInjectionPoint
	{
		private var methodName:String;
		private var argTypes:Array;
		
		public function InjectionPointMethod(methodName:String, argTypes:Array)
		{
			this.methodName = methodName;
			this.argTypes = argTypes.map(toClass);
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var method:Function = target[methodName];
			if(null == argTypes || 0 == argTypes.length){
				method();
			}else{
				method.apply(null, getInstances(injector));
			}
		}
		
		private function getInstances(injector:IInjector):Array
		{
			var count:int = argTypes.length;
			var result:Array = new Array(count);
			for(var i:int=0; i<count; i++){
				result[i] = injector.getInstance(argTypes[i]);
			}
			return result;
		}
		
		static private function toClass(type:String, index:int, array:Array):Class
		{
			return getDefinitionByName(type) as Class;
		}
	}
}