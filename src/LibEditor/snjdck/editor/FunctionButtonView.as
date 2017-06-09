package snjdck.editor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	import flash.text.TextField;
	
	import snjdck.ui.utils.TextFieldFactory;
	
	public class FunctionButtonView extends Sprite
	{
		private var alignBtn:TextField;
		
		public const clickSignal:Signal = new Signal(String);
		
		public function FunctionButtonView()
		{
			alignBtn = TextFieldFactory.Create(this);
			alignBtn.text = "左对齐";
			
			alignBtn.addEventListener(MouseEvent.CLICK, __onAlign);
		}
		
		private function __onAlign(evt:MouseEvent):void
		{
			clickSignal.notify("align left");
		}
	}
}