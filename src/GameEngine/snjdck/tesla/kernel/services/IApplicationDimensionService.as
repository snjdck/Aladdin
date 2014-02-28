package snjdck.tesla.kernel.services
{
	import flash.signals.ISignal;

	public interface IApplicationDimensionService
	{
		function get resizeSignal():ISignal;
		function get width():int;
		function get height():int;
	}
}