package flash.ioc
{
	internal class InjectionPointMethod0 implements IInjectionPoint
	{
		private var name:String;
		
		public function InjectionPointMethod0(name:String)
		{
			this.name = name;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			target[name]();
		}
	}
}