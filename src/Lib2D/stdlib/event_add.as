package stdlib
{
	import flash.events.IEventDispatcher;

	public function event_add(target:IEventDispatcher, evtType:String, listener:Function):void
	{
		if(target){
			target.addEventListener(evtType, listener);
		}
	}
}