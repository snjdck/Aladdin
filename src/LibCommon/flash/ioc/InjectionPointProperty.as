package flash.ioc
{
	internal class InjectionPointProperty implements IInjectionPoint
	{
		private var name:String;
		private var info:Object;
		private var type:String;
		
		public function InjectionPointProperty(name:String, info:Object, type:String)
		{
			this.name = name;
			this.info = info;
			this.type = type;
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