package flash.ioc
{
	internal interface IInjectionPoint
	{
		function injectInto(target:Object, injector:IInjector):void;
	}
}