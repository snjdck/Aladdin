package snjdck.injector.ip
{
	import snjdck.injector.IInjector;

	internal interface IInjectionPoint
	{
		function injectInto(target:Object, injector:IInjector):void;
		function get priority():int;
		function getTypesNeedToBeInjected(result:Array):void;
	}
}