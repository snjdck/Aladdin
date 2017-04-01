package snjdck.ui
{
	import flash.display.Sprite;
	
	public class Component extends Sprite
	{
		protected var _width:Number;
		protected var _height:Number;
		
		public function Component(){}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
	}
}