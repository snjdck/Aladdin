package ui.button
{
	public interface IButtonGroup
	{
		function addButton(button:Button):void;
		function setSelected(button:Button, value:Boolean):void;
	}
}