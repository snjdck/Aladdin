package flash.ioc.it
{
	import flash.ioc.IInjector;
	import flash.ioc.IInjectionType;

	[ExcludeClass]
	final public class InjectionTypeValue implements IInjectionType
	{
		private var realInjector:IInjector;
		private var needInject:Boolean;
		private var val:Object;
		
		public function InjectionTypeValue(val:Object, needInject:Boolean, realInjector:IInjector)
		{
			this.realInjector = realInjector;
			this.needInject = needInject;
			this.val = val;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(needInject){
				needInject = false;
				realInjector.injectInto(val);
			}
			return val;
		}
	}
}