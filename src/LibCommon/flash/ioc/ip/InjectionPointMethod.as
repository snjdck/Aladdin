package flash.ioc.ip
{
	import array.append;
	
	import flash.ioc.IInjector;
	
	import lambda.apply;

	internal class InjectionPointMethod implements IInjectionPoint
	{
		private var methodName:String;
		private var argTypes:Array;
		
		public function InjectionPointMethod(methodName:String, argTypes:Array)
		{
			this.methodName = methodName;
			this.argTypes = argTypes;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			lambda.apply(target[methodName], argTypes && injector.getInstances(argTypes));
		}
		
		public function getTypesNeedInject(result:Array):void
		{
			array.append(result, argTypes);
		}
	}
}