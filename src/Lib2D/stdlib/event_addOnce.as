package stdlib
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import lambda.execFunc;

	public function event_addOnce(target:IEventDispatcher, evtType:String, listener:Function):void
	{
		target.addEventListener(target, evtType, function(evt:Event):void{
			target.removeEventListener(evtType, arguments.callee);
			execFunc(listener, evt);
		});
	}
}