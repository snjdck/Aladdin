package snjdck.effect.tween.impl
{
	import snjdck.effect.tween.ITween;

	internal class ParallelTweenGroup extends TweenGroup
	{
		public function ParallelTweenGroup()
		{
			super();
		}
		
		override public function get duration():Number
		{
			var tween:ITween = getTargetTween();
			return tween ? tween.duration : 0;
		}
		
		override public function play():void
		{
			if(isPlaying){
				return;
			}
			isPlaying = true;
			if(subTweenList.length <= 0){
				_completeSignal.notify();
				return;
			}
			getTargetTween().completeSignal.add(_completeSignal.notify, true);
			for each(var tween:ITween in subTweenList){
				tween.play();
			}
		}
		
		private function getTargetTween():ITween
		{
			var result:ITween;
			for each(var tween:ITween in subTweenList){
				if(null == result || result.duration < tween.duration){
					result = tween;
				}
			}
			return result;
		}
	}
}