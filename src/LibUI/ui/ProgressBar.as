package ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import ui.support.createBox;
	
	public class ProgressBar extends Sprite
	{
		private var trackUI:DisplayObject;
		private var thumbUI:DisplayObject;
		
		private var _value:Number = 0;
		
		public function ProgressBar()
		{
			super();
		}
		
		protected function createChildren():void
		{
			trackUI = createBox(100, 20);
			thumbUI = createBox(100, 20, 0xFF00, 0.6);
			
			addChild(trackUI);
			addChild(thumbUI);
			
			this.width = trackUI.width;
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = (value > 1) ? 1 : (value < 0 ? 0 : value);
			redraw();
		}
		
		override public function set width(value:Number):void
		{
			trackUI.width = width;
			redraw();
		}
		
		private function redraw():void
		{
			thumbUI.width = width * value;
		}
	}
}