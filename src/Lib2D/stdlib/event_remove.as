package stdlib
{
	import flash.events.IEventDispatcher;

	public function event_remove(target:IEventDispatcher, evtType:String, listener:Function):void
	{
		if(target){
			target.removeEventListener(evtType, listener);
		}
	}
}