package flash.ioc.it
{
	import flash.ioc.IInjector;
	import flash.ioc.IInjectionType;

	[ExcludeClass]
	final public class InjectionTypeSingleton implements IInjectionType
	{
		private var realInjector:IInjector;
		private var cls:Class;
		private var val:Object;
		
		public function InjectionTypeSingleton(realInjector:IInjector, cls:Class)
		{
			this.realInjector = realInjector;
			this.cls = cls;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(null == val){
				val = new cls();
				realInjector.injectInto(val);
			}
			return val;
		}
	}
}