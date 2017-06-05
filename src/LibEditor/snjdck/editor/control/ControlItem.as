package snjdck.editor.control
{
	import flash.display.Sprite;
	
	import snjdck.editor.codegen.ClassFactory;
	
	public class ControlItem extends Sprite
	{
		private var config:XML;
		private var item:Sprite;
		
		public function ControlItem(config:XML)
		{
			this.config = config;
			item = create();
		}
		
		internal function create():Sprite
		{
			var item:Sprite = ClassFactory.Instance.create(config, null);
			addChild(item);
			return item;
		}
	}
}