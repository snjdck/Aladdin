package flash.ioc.it
{
	import flash.ioc.IInjector;

	[ExcludeClass]
	final public class InjectionTypeSingleton extends InjectionTypeClass
	{
		private var val:Object;
		
		public function InjectionTypeSingleton(realInjector:IInjector, cls:Class)
		{
			super(realInjector, cls);
		}
		
		override public function getValue(injector:IInjector, id:String):Object
		{
			if(null == val){
				val = new cls();
				realInjector.injectInto(val);
			}
			return val;
		}
	}
}