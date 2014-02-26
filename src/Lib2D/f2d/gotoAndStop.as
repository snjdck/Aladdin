package f2d
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.listenEventOnce;

	public function gotoAndStop(target:MovieClip, frame:Object, callback:Function=null):void
	{
		if(null != callback){
			listenEventOnce(target, Event.FRAME_CONSTRUCTED, callback);
		}
		target.gotoAndStop(frame);
	}
}