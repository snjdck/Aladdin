package snjdck.effect.tween
{
	public interface ITweenBuilder
	{
		function getRootTween():ITween;
		
		function tween(target:Object, duration:Number, vars:Object, option:TweenOption=null):ITweenBuilder;
		
		function parallelBegin():ITweenBuilder;
		function parallelEnd():ITweenBuilder;
		
		function sequenceBegin():ITweenBuilder;
		function sequenceEnd():ITweenBuilder;
	}
}