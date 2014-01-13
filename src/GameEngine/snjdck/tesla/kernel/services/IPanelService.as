package snjdck.tesla.kernel.services
{
	import snjdck.mvc.core.IService;
	import snjdck.signal.ISignal;
	import snjdck.tesla.core.IPanel;

	public interface IPanelService extends IService
	{
		function register(panel:IPanel):void;
		
		function panelShownSignal():ISignal;
		function panelHiddenSignal():ISignal;
	}
}