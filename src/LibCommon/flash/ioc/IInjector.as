package flash.ioc
{
	[ExcludeClass]
	public interface IInjector
	{
		function getInstance(type:Class, id:String=null):*;
		function injectInto(target:Object):void;
	}
}