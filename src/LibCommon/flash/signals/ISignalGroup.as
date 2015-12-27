package flash.signals
{
	public interface ISignalGroup
	{
		function addListener(evtName:String, handler:Function, once:Boolean=false):void;
		function removeListener(evtName:String, handler:Function):void;
		function hasListener(evtName:String, handler:Function):Boolean;
		function notify(evtName:String, arg:Object):void;
	}
}