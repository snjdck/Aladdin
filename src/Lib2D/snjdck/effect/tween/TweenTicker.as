package snjdck.effect.tween
{
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
			
			for each(var tween:Tween in tweenDict){
				while(tween){
					tween.update(timeElapsed);
					tween = tween.nextSibling;
				}
			}
		}
		
		public function killTweensOf(target:Object):void
		{
			delete tweenDict[target];
		}
		
		public function addTween(tween:Tween):void
		{
			if(isTweenRunning(tween)){
				return;
			}
			var firstTween:Tween = tweenDict[tween.target];
			tween.nextSibling = firstTween;
			tween.delConflictPropsOnOtherTweens(firstTween);
			tweenDict[tween.target] = tween;
		}
		
		public function removeTween(tween:Tween):void
		{
			var firstTween:Tween = tweenDict[tween.target];
			if(null == firstTween){
				return;
			}
			if(firstTween == tween){
				tweenDict[tween.target] = tween.nextSibling;
				return;
			}
			while(firstTween.nextSibling){
				if(firstTween.nextSibling == tween){
					firstTween.nextSibling = tween.nextSibling;
					return;
				}
				firstTween = firstTween.nextSibling;
			}
		}
		
		public function isTweenRunning(tween:Tween):Boolean
		{
			var firstTween:Tween = tweenDict[tween.target];
			while(firstTween){
				if(firstTween == tween){
					return true;
				}
				firstTween = firstTween.nextSibling;
			}
			return false;
		}
	}
}