package flash.ioc
{
	internal class InjectionTypeClass implements IInjectionType
	{
		private var realInjector:IInjector;
		private var klass:Class;
		
		public function InjectionTypeClass(realInjector:IInjector, klass:Class)
		{
			this.realInjector = realInjector;
			this.klass = klass;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			var value:Object = new klass();
			realInjector.injectInto(value);
			return value;
		}
	}
}