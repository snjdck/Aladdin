package flash.ioc.ip
{
	import array.append;
	
	import lambda.apply;
	
	import flash.ioc.IInjector;

	final internal class InjectionPointMethod extends InjectionPoint implements IInjectionPoint
	{
		private var argTypes:Array;
		
		public function InjectionPointMethod(name:String, info:Object, argTypes:Array)
		{
			super(name, info);
			this.argTypes = argTypes;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			lambda.apply(target[name], getArgValues(argTypes, injector));
		}
		
		public function get priority():int
		{
			return argTypes.length > 0 ? 2 : 3;
		}
		
		public function getTypesNeedToBeInjected(result:Array):void
		{
			array.append(result, argTypes);
		}
	}
}