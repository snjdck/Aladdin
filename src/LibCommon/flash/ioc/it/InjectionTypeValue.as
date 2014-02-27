package flash.ioc.it
{
	import flash.ioc.IInjector;

	[ExcludeClass]
	final public class InjectionTypeValue implements IInjectionType
	{
		private var needInject:Boolean;
		private var hasInjected:Boolean;
		private var val:Object;
		
		public function InjectionTypeValue(val:Object, needInject:Boolean)
		{
			this.needInject = needInject;
			this.val = val;
		}
		
		public function getValue(injector:IInjector, id:String):Object
		{
			if(id){
				return null;
			}
			if(needInject && !hasInjected){
				injector.injectInto(val);
				hasInjected = true;
			}
			return val;
		}
	}
}