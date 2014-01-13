package f2d
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import stdlib.event_addOnce;

	public function gotoAndStop(target:MovieClip, frame:Object, callback:Function=null):void
	{
		if(null != callback){
			event_addOnce(target, Event.FRAME_CONSTRUCTED, callback);
		}
		target.gotoAndStop(frame);
	}
}