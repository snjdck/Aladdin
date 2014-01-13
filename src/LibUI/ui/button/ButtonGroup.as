package ui.button
{
	public class ButtonGroup implements IButtonGroup
	{
		private var focusButton:Button;
		
		public function ButtonGroup()
		{
		}
		
		public function addButton(button:Button):void
		{
			button.group = this;
		}
		
		public function setSelected(button:Button, value:Boolean):void
		{
			if(focusButton){
				focusButton.selected = false;
			}
			focusButton = button;
			if(focusButton){
				focusButton.selected = true;
			}
		}
	}
}