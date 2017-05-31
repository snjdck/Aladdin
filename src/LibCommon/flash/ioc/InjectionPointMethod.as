package flash.ioc
{
	internal class InjectionPointMethod implements IInjectionPoint
	{
		private var name:String;
		private var argTypes:Array;
		private var argCount:int;
		private var argValues:Array;
		
		public function InjectionPointMethod(name:String, argTypes:Array)
		{
			this.name = name;
			this.argTypes = argTypes;
			argCount = argTypes.length;
			argValues = new Array(argCount);
		}
		
		public function injectInto(target:Object, injector:IInjector):void
		{
			var i:int;
			for(i=0; i<argCount; ++i)argValues[i] = injector.getInstance(argTypes[i]);
			target[name].apply(null, argValues);
			for(i=0; i<argCount; ++i)argValues[i] = null;
		}
	}
}