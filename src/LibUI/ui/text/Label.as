package ui.text
{
	import flash.text.TextFieldAutoSize;

	public class Label extends TextComponent
	{
		public function Label()
		{
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			labelTf.autoSize = TextFieldAutoSize.LEFT;
			mouseChildren = false;
		}
	}
}