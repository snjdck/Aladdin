package flash.ioc.it
{
	import flash.ioc.IInjector;
	import flash.ioc.IInjectionType;

	[ExcludeClass]
	public class InjectionTypeValue implements IInjectionType
	{
		private var realInjector:IInjector;
		private var value:Object;
		
		public function InjectionTypeValue(realInjector:IInjector, value:Object)
		{
			this.realInjector = realInjector;
			this.value = value;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(null != realInjector){
				realInjector.injectInto(value);
				realInjector = null;
			}
			return value;
		}
	}
}