package flash.ioc.it
{
	import flash.ioc.IInjectionType;
	import flash.ioc.IInjector;

	[ExcludeClass]
	public class InjectionTypeClass implements IInjectionType
	{
		protected var realInjector:IInjector;
		protected var klass:Class;
		
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