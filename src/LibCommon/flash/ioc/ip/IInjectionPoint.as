package flash.ioc.ip
{
	import flash.ioc.IInjector;

	internal interface IInjectionPoint
	{
		function injectInto(target:Object, injector:IInjector):void;
		function getTypesNeedInject(result:Array):void;
	}
}