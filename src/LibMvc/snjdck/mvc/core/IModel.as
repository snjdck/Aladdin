package snjdck.mvc.core
{
	public interface IModel
	{
		function regProxy(proxyCls:Class):void;
		function delProxy(proxyCls:Class):void;
		function hasProxy(proxyCls:Class):Boolean;
	}
}