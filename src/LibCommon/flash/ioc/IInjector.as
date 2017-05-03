package flash.ioc
{
	internal interface IInjector
	{
		function getInstance(type:*, id:String=null):*;
		function injectInto(target:Object):void;
	}
}