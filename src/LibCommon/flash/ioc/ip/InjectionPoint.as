package flash.ioc.ip
{
	import flash.ioc.IInjector;

	internal class InjectionPoint
	{
		protected var name:String;
		protected var info:Object;
		
		public function InjectionPoint(name:String, info:Object)
		{
			this.name = name;
			this.info = info;
		}
		
		final protected function getArgValues(argTypes:Array, injector:IInjector):Array
		{
			var argValues:Array = [];
			for(var i:int=0, n:int=argTypes.length; i<n; i++){
				argValues[i] = injector.getInstance(argTypes[i], info ? info[i] : null);
			}
			return argValues;
		}
	}
}