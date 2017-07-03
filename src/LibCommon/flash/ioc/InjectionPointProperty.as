package flash.ioc
{
	internal class InjectionPointProperty implements IInjectionPoint
	{
		private var name:String;
		private var type:String;
		private var info:Object;
		
		public function InjectionPointProperty(name:String, type:String, info:Object)
		{
			this.name = name;
			this.type = type;
			this.info = info;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var value:Object = injector.getInstance(type, info[0]);
			if(null != value){
				target[name] = value;
			}
		}
	}
}