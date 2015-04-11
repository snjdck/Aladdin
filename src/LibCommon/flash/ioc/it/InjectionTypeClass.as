package flash.ioc.it
{
	import flash.ioc.IInjectionType;
	import flash.ioc.IInjector;

	[ExcludeClass]
	final public class InjectionTypeClass implements IInjectionType
	{
		private var realInjector:IInjector;
		private var cls:Class;
		
		public function InjectionTypeClass(realInjector:IInjector, cls:Class)
		{
			this.realInjector = realInjector;
			this.cls = cls;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			var val:Object = new cls();
			realInjector.injectInto(val);
			return val;
		}
	}
}