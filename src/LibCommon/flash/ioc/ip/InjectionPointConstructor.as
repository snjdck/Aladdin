package flash.ioc.ip
{
	import array.append;
	
	import flash.ioc.IInjector;
	
	import lambda.apply;

	internal class InjectionPointConstructor
	{
		private var clsRef:Class;
		private var argTypes:Array;
		
		public function InjectionPointConstructor(clsRef:Class, argTypes:Array)
		{
			this.clsRef = clsRef;
			this.argTypes = argTypes;
		}
		
		public function newInstance(injector:IInjector):Object
		{
			return lambda.apply(clsRef, argTypes && injector.getInstances(argTypes));
		}
		
		public function getTypesNeedInject(result:Array):void
		{
			array.append(result, argTypes);
		}
	}
}