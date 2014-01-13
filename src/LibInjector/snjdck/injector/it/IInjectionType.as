package snjdck.injector.it
{
	import snjdck.injector.IInjector;

	[ExcludeClass]
	public interface IInjectionType
	{
		function getValue(injector:IInjector, id:String):Object;
	}
}