package flash.ioc
{
	internal class InjectionTypeSingleton implements IInjectionType
	{
		private var realInjector:IInjector;
		private var klass:Class;
		private var value:Object;
		
		public function InjectionTypeSingleton(realInjector:IInjector, klass:Class)
		{
			this.realInjector = realInjector;
			this.klass = klass;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(null == value){
				value = new klass();
				realInjector.injectInto(value);
				realInjector = null;
				klass = null;
			}
			return value;
		}
	}
}