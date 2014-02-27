package flash.ioc.it
{
	import flash.ioc.IInjector;

	[ExcludeClass]
	final public class InjectionTypeSingleton implements IInjectionType
	{
		private var cls:Class;
		private var val:Object;
		
		public function InjectionTypeSingleton(cls:Class)
		{
			this.cls = cls;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(id){
				return null;
			}
			return val ||= injector.newInstance(cls);
		}
	}
}