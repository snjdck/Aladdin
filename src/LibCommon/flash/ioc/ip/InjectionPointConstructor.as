package flash.ioc.ip
{
	import array.append;
	
	import lambda.apply;
	
	import flash.ioc.IInjector;

	internal class InjectionPointConstructor extends InjectionPoint
	{
		private var argTypes:Array;
		
		public function InjectionPointConstructor(name:String, info:Object, argTypes:Array)
		{
			super(name, info);
			this.argTypes = argTypes;
		}
		
		public function newInstance(injector:IInjector):Object
		{
			return lambda.apply(name, argTypes && getArgValues(argTypes, injector));
		}
		
		public function getTypesNeedToBeInjected(result:Array):void
		{
			array.append(result, argTypes);
		}
	}
}