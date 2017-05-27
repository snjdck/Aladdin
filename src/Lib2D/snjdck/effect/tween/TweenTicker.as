package snjdck.effect.tween
{
	import flash.utils.Dictionary;
	
	import array.del;
	import array.has;
	
	import snjdck.clock.Clock;
	import snjdck.clock.ITicker;

	final internal class TweenTicker implements ITicker
	{
		private const tweenDict:Object = new Dictionary();
		
		public function TweenTicker()
		{
			Clock.getInstance().add(this);
		}
		
		public function onTick(timeElapsed:int):void
		{
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
			if(hasTween(tween)){
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
		
		public function hasTween(tween:Tween):Boolean
		{
			var tweenList:Vector.<Tween> = getTweenList(tween.target);
			return array.has(tweenList, tween);
		}
		
		private function getTweenList(target:Object):Vector.<Tween>
		{
			if($dict.hasKey(tweenDict, target) == false){
				tweenDict[target] = new Vector.<Tween>();
			}
			return tweenDict[target];
		}
	}
}