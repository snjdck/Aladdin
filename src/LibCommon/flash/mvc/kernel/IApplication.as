package flash.mvc.kernel
{
	import flash.ioc.IInjector;
	import flash.mvc.Module;

	public interface IApplication
	{
		function regModule(module:Module):void;
		function regService(serviceInterface:Class, serviceClass:Class, moduleInjector:IInjector=null):void;
		
		function getInjector():IInjector;
		
		function startup():void;
		function shutdown():void;
	}
}