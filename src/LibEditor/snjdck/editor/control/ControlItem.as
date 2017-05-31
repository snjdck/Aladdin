package snjdck.editor.control
{
	import flash.display.Sprite;
	
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
			var item:Sprite = $lambda.apply(config["@class"].toString());
			addChild(item);
			for each(var node:XML in config.attributes()){
				var key:String = node.name().toString();
				var value:String = node.toString();
				if(key == "class"){
					continue;
				}
				item[key] = value;
			}
			return item;
		}
	}
}