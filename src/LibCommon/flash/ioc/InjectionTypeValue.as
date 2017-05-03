package flash.ioc
{
	internal class InjectionTypeValue implements IInjectionType
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
				injector = realInjector;
				realInjector = null;
				injector.injectInto(value);
			}
			return value;
		}
	}
}