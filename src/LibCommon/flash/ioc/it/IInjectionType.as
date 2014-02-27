package flash.ioc.it
{
	import flash.ioc.IInjector;

	[ExcludeClass]
	public interface IInjectionType
	{
		function getValue(injector:IInjector, id:String):Object;
	}
}