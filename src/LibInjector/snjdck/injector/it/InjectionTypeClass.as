package snjdck.injector.it
{
	import snjdck.injector.IInjector;

	[ExcludeClass]
	final public class InjectionTypeClass implements IInjectionType
	{
		private var cls:Class;
		
		public function InjectionTypeClass(cls:Class)
		{
			this.cls = cls;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(id){
				return null;
			}
			return injector.newInstance(cls);
		}
	}
}