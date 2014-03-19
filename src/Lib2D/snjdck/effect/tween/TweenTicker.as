package snjdck.effect.tween
{
	import array.del;
	import array.has;
	
	import dict.hasKey;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	final internal class TweenTicker
	{
		private const tweenDict:Object = new Dictionary();
		private const evtSource:Shape = new Shape();
		private var timestamp:int;
		
		public function TweenTicker()
		{
			evtSource.addEventListener(Event.ENTER_FRAME, __onTick);
			timestamp = getTimer();
		}
		
		private function __onTick(evt:Event):void
		{
			var now:int = getTimer();
			var timeElapsed:int = now - timestamp;
			timestamp = now;
			
			for each(var tweenList:Vector.<Tween> in tweenDict){
				for each(var tween:Tween in tweenList){
					tween.update(timeElapsed);
				}
			}
		}
		
		public function killTweensOf(target:Object):void
		{
			var tweenList:Vector.<Tween> = getTweenList(target);
			tweenList.length = 0;
		}
		
		public function addTween(tween:Tween):void
		{
			if(isTweenRunning(tween)){
				return;
			}
			var tweenList:Vector.<Tween> = getTweenList(tween.target);
			tween.delConflictPropsOnOtherTweens(tweenList);
			tweenList.push(tween);
		}
		
		public function removeTween(tween:Tween):void
		{
			var tweenList:Vector.<Tween> = getTweenList(tween.target);
			array.del(tweenList, tween);
		}
		
		public function isTweenRunning(tween:Tween):Boolean
		{
			var tweenList:Vector.<Tween> = getTweenList(tween.target);
			return array.has(tweenList, tween);
		}
		
		private function getTweenList(target:Object):Vector.<Tween>
		{
			if(dict.hasKey(tweenDict, target) == false){
				tweenDict[target] = new Vector.<Tween>();
			}
			return tweenDict[target];
		}
	}
}