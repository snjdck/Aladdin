package flash.ioc
{
	internal class InjectionPointMethod implements IInjectionPoint
	{
		private var name:String;
		private var argTypes:Array;
		
		public function InjectionPointMethod(name:String, argTypes:Array)
		{
			this.name = name;
			this.argTypes = argTypes;
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var method:Function = target[name];
			if(argTypes.length > 0){
				method.apply(null, getArgs(injector));
			}else{
				method();
			}
		}
		
		private function getArgs(injector:IInjector):Array
		{
			var count:int = argTypes.length;
			var result:Array = new Array(count);
			for(var i:int=0; i<count; ++i){
				result[i] = injector.getInstance(argTypes[i]);
			}
			return result;
		}
	}
}