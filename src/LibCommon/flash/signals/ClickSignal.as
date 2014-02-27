package flash.signals
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class ClickSignal extends EventSignal
	{
		public function ClickSignal(uiTarget:InteractiveObject)
		{
			super(uiTarget, MouseEvent.CLICK);
		}
	}
}