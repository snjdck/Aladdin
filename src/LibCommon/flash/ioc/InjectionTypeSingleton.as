package flash.ioc
{
	internal class InjectionTypeSingleton extends InjectionTypeClass
	{
		private var value:Object;
		
		public function InjectionTypeSingleton(realInjector:IInjector, klass:Class)
		{
			super(realInjector, klass);
		}
		
		override public function getValue(injector:IInjector, id:String):Object
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