package snjdck.effect.tween.impl
{
	import snjdck.effect.tween.ITween;
	import snjdck.effect.tween.ITweenBuilder;
	import snjdck.effect.tween.ITweenGroup;
	import snjdck.effect.tween.TweenOption;
	
	public class TweenBuilder implements ITweenBuilder
	{
		private var tweenStack:Vector.<ITweenGroup>;
		
		public function TweenBuilder()
		{
			tweenStack = new Vector.<ITweenGroup>();
			tweenStack.push(new ParallelTweenGroup());
		}
		
		private function get currentTween():ITweenGroup
		{
			if(tweenStack.length <= 0){
				return null;
			}
			return tweenStack[tweenStack.length-1];
		}
		
		private function pushTween(tween:ITweenGroup):void
		{
			currentTween.addTween(tween);
			tweenStack.push(tween);
		}
		
		private function popTween():void
		{
			tweenStack.pop();
		}
		
		public function tween(target:Object, duration:Number, props:Object, option:TweenOption=null):ITweenBuilder
		{
			currentTween.addTween(new Tween(target, duration, props));
			return this;
		}
		
		public function parallelBegin():ITweenBuilder
		{
			pushTween(new ParallelTweenGroup());
			return this;
		}
		
		public function parallelEnd():ITweenBuilder
		{
			popTween();
			return this;
		}
		
		public function sequenceBegin():ITweenBuilder
		{
			pushTween(new SequenceTweenGroup());
			return this;
		}
		
		public function sequenceEnd():ITweenBuilder
		{
			popTween();
			return this;
		}
		
		public function getRootTween():ITween
		{
			return tweenStack[0];
		}
		
	}
}