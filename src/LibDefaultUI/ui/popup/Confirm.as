package ui.popup
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.xmlui.button.Button;
	
	import ui.core.Container;
	
	public class Confirm extends Frame
	{
		static public const BUTTON_YES:int = 3;
		static public const BUTTON_NO:int = 4;
		
		private var yesBtn:Button;
		private var noBtn:Button;
		
		public function Confirm()
		{
			yesBtn = new NormalButton();
			addChild(yesBtn);
			yesBtn.addEventListener(MouseEvent.CLICK, __onYes);
			
			noBtn = new NormalButton();
			addChild(noBtn);
			noBtn.addEventListener(MouseEvent.CLICK, __onNo);
			
			yesBtn.y = noBtn.y = 110;
			yesBtn.x = (width - (yesBtn.width + noBtn.width)) / 3;
			noBtn.x = (width - (yesBtn.width + noBtn.width)) / 3 * 2 + yesBtn.width;
		}
		
		private function __onYes(evt:Event):void
		{
			closedSignal.notify(BUTTON_YES);
		}
		
		private function __onNo(evt:Event):void
		{
			closedSignal.notify(BUTTON_NO);
		}
	}
}