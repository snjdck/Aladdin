package snjdck.effect.tween.impl
{
	import snjdck.effect.tween.ITween;
	import snjdck.effect.tween.ITweenGroup;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	
	internal class TweenGroup implements ITweenGroup
	{
		protected var subTweenList:Vector.<ITween>;
		protected var _completeSignal:Signal;
		
		protected var isPlaying:Boolean;
		
		public function TweenGroup()
		{
			subTweenList = new Vector.<ITween>();
			_completeSignal = new Signal();
		}
		
		public function addTween(tween:ITween):void
		{
			subTweenList.push(tween);
		}
		
		final public function get completeSignal():ISignal
		{
			return _completeSignal;
		}
		
		public function get duration():Number
		{
			return 0;
		}
		
		public function play():void
		{
			isPlaying = true;
		}
	}
}