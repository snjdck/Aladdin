package snjdck.effect.tween.impl
{
	import snjdck.effect.tween.ITween;

	internal class SequenceTweenGroup extends TweenGroup
	{
		public function SequenceTweenGroup()
		{
			super();
		}
		
		override public function get duration():Number
		{
			var result:Number = 0;
			for each(var tween:ITween in subTweenList){
				result += tween.duration;
			}
			return result;
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
			for(var index:int=0, n:int=subTweenList.length-1; index<n; index++){
				subTweenList[index].completeSignal.add(subTweenList[index+1].play, true);
			}
			var firstTween:ITween = subTweenList[0];
			firstTween.play();
		}
		
		private function getTargetTween():ITween
		{
			if(subTweenList.length <= 0){
				return null;
			}
			return subTweenList[subTweenList.length-1];
		}
	}
}