package ui.popup
{
	import flash.events.MouseEvent;
	
	import org.xmlui.button.Button;
	
	import ui.core.Container;
	
	public class Alert extends Frame
	{
		static public const BUTTON_OK:int = 2;
		
		private var okBtn:Button;
		
		public function Alert()
		{
			super();
			okBtn = new NormalButton();
			addChild(okBtn);
			okBtn.addEventListener(MouseEvent.CLICK, __onOk);
			
			okBtn.x = 0.5 * (width - okBtn.width);
			okBtn.y = 110;
		}
		
		private function __onOk(evt:MouseEvent):void
		{
			closedSignal.notify(BUTTON_OK);
		}
	}
}