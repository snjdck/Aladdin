package snjdck.ui.menu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MenuItem extends Sprite
	{
		public var menu:Menu;
		public var subMenu:Menu;
		
		private var tf:TextField;
		
		public var data:*;
		public var handler:Object;
		
		private var _width:Number = 0;
		static public var marginLeft:int = 12;
		static public var marginRight:int = 22;
		
		public function MenuItem()
		{
			tf = new TextField();
			tf.x = marginLeft;
			tf.y = 2;
			tf.defaultTextFormat = new TextFormat("宋体", 12);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			addChild(tf);
			addEventListener(MouseEvent.ROLL_OVER, __onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, __onMouseOut);
		}
		
		public function set enabled(value:Boolean):void
		{
			
		}
		
		public function set checked(value:Boolean):void
		{
			
		}
		
		public function get label():String
		{
			return tf.text;
		}
		
		public function set label(value:String):void
		{
			tf.text = value;
		}
		
		private function __onMouseOver(evt:MouseEvent):void
		{
			drawBG(0xFF00, 0.5);
			if(subMenu != null){
				subMenu.layout();
				addChild(subMenu);
				subMenu.x = _width - 2;
			}
		}
		
		private function __onMouseOut(evt:MouseEvent):void
		{
			drawBG(0, 0);
			if(subMenu != null){
				removeChild(subMenu);
			}
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			drawBG(0, 0);
		}
		
		private function drawBG(color:uint, alpha:Number):void
		{
			graphics.clear();
			graphics.beginFill(color, alpha);
			graphics.drawRect(2, 2, _width-4, height-4);
			graphics.endFill();
		}
		
		override public function get width():Number
		{
			return tf.width + marginLeft + marginRight;
		}
		
		override public function get height():Number
		{
			return tf.height + 4;
		}
	}
}