package flash.ioc.it
{
	import flash.ioc.IInjector;
	import flash.ioc.IInjectionType;

	[ExcludeClass]
	public class InjectionTypeValue implements IInjectionType
	{
		private var realInjector:IInjector;
		private var needInject:Boolean;
		private var value:Object;
		
		public function InjectionTypeValue(value:Object, needInject:Boolean, realInjector:IInjector)
		{
			this.realInjector = realInjector;
			this.needInject = needInject;
			this.value = value;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(needInject){
				needInject = false;
				realInjector.injectInto(value);
				realInjector = null;
			}
			return value;
		}
	}
}