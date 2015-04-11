package flash.ioc
{
	[ExcludeClass]
	public interface IInjectionPoint
	{
		function injectInto(target:Object, injector:IInjector):void;
	}
}