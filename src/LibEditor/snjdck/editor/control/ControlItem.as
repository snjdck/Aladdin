package snjdck.editor.control
{
	import flash.display.Sprite;
	
	import snjdck.editor.codegen.ClassFactory;
	import snjdck.ui.utils.TextFieldFactory;
	
	public class ControlItem extends Sprite
	{
		private var config:XML;
		
		public function ControlItem(config:XML)
		{
			this.config = config;
			TextFieldFactory.Create(this).text = config.name().toString();
		}
		
		internal function create():Sprite
		{
			return ClassFactory.Instance.create(config, null);
		}
	}
}