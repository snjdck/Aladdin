package snjdck.effect.tween
{
	import snjdck.signal.ISignal;

	public interface ITween
	{
		function get duration():Number;
		function get completeSignal():ISignal;
		function play():void;
	}
}