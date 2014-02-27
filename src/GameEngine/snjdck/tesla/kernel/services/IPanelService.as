package snjdck.tesla.kernel.services
{
	import snjdck.mvc.core.IService;
	import flash.signals.ISignal;
	import snjdck.tesla.core.IPanel;

	public interface IPanelService extends IService
	{
		function register(panel:IPanel):void;
		
		function panelShownSignal():ISignal;
		function panelHiddenSignal():ISignal;
	}
}