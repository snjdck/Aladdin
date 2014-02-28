package snjdck.tesla.kernel.services
{
	import flash.signals.ISignal;
	
	import snjdck.tesla.core.IPanel;

	public interface IPanelService
	{
		function register(panel:IPanel):void;
		
		function panelShownSignal():ISignal;
		function panelHiddenSignal():ISignal;
	}
}