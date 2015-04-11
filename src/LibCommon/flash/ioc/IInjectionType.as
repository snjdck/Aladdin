package flash.ioc
{
	public interface IInjectionType
	{
		function getValue(injector:IInjector, id:String):Object;
	}
}