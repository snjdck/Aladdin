package snjdck.mvc.core
{
	public interface IModule
	{
		function regService(serviceInterface:Class, serviceClass:Class, asLocal:Boolean=false):void;
		
		function initAllModels():void;
		function initAllServices():void;
		function initAllViews():void;
		function initAllControllers():void;
	}
}