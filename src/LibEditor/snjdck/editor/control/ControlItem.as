package snjdck.editor.control
{
	import flash.display.Sprite;
	
	import snjdck.ui.utils.TextFieldFactory;
	
	internal class ControlItem extends Sprite
	{
		internal var config:XML;
		
		public function ControlItem(config:XML)
		{
			this.config = config;
			TextFieldFactory.Create(this).text = config.name().toString();
		}
	}
}