package snjdck.effect.tween
{
	import flash.signals.ISignal;

	public interface ITween
	{
		function get duration():Number;
		function get completeSignal():ISignal;
		function play():void;
	}
}