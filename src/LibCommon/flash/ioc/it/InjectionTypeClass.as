package flash.ioc.it
{
	import flash.ioc.IInjectionType;
	import flash.ioc.IInjector;

	[ExcludeClass]
	public class InjectionTypeClass implements IInjectionType
	{
		protected var realInjector:IInjector;
		protected var cls:Class;
		
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