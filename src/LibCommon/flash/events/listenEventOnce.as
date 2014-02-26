package flash.events
{
	import lambda.execFunc;

	public function listenEventOnce(target:IEventDispatcher, evtType:String, listener:Function):void
	{
		target.addEventListener(evtType, function(evt:Event):void{
			target.removeEventListener(evtType, arguments.callee);
			execFunc(listener, evt);
		});
	}
}