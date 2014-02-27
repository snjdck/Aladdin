package snjdck.tesla.kernel.services
{
	import snjdck.mvc.core.IService;
	import flash.signals.ISignal;

	public interface IApplicationDimensionService extends IService
	{
		function get resizeSignal():ISignal;
		function get width():int;
		function get height():int;
	}
}