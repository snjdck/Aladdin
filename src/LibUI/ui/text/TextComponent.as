package ui.text
{
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ui.core.Component;
	
	internal class TextComponent extends Component
	{
		protected var labelTf:TextField;
		
		public function TextComponent()
		{
		}
		
		override protected function createChildren():void
		{
			labelTf = new TextField();
			labelTf.defaultTextFormat = new TextFormat("微软雅黑", 12, 0xE7E6E5);
			labelTf.filters = [new GlowFilter(0x000000, 1, 2, 2, 8), new DropShadowFilter(1, 90, 0x000000, 0.75, 2, 2, 1)];
			labelTf.mouseWheelEnabled = false;
			addChild(labelTf);
		}
		
		override public function onResize():void
		{
			super.onResize();
			labelTf.width = width;
			labelTf.height = height;
		}
		
		public function get text():String
		{
			return labelTf.text;
		}
		
		public function set text(value:String):void
		{
			labelTf.text = value;
		}
		
		public function get htmlText():String
		{
			return labelTf.htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			labelTf.htmlText = value;
		}
		
		public function appendText(newText:String):void
		{
			labelTf.appendText(newText);
		}
		
		public function getImageReference(id:String):DisplayObject
		{
			return labelTf.getImageReference(id);
		}
		
		public function get selectable():Boolean
		{
			return labelTf.selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			labelTf.selectable = value;
		}
		
		public function get textFilters():Array
		{
			return labelTf.filters;
		}
		
		public function setFormat(color:uint, size:int=0, font:String=null):void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = font || labelTf.defaultTextFormat.font;
			textFormat.size = (size > 0) ? size : labelTf.defaultTextFormat.size;
			textFormat.color = color;
			
			labelTf.defaultTextFormat = textFormat;
			labelTf.setTextFormat(textFormat);
		}
		
		public function set textFilters(value:Array):void
		{
			labelTf.filters = value;
		}
		
		public function getRawTextField():TextField
		{
			return labelTf;
		}
	}
}