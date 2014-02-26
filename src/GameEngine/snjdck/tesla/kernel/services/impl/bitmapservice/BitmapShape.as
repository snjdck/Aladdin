package snjdck.tesla.kernel.services.impl.bitmapservice
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Scale9GridDrawer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	internal class BitmapShape extends Sprite
	{
		private var _bitmapData:BitmapData;
		private var _scale9Grid:Rectangle;
		
		public function BitmapShape(width:int, height:int)
		{
			this._bitmapData = new BitmapData(width, height, true, 0xFF000000);
			this._scale9Grid = new Rectangle(0, 0, width, height);
			init(width, height);
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
		private function init(width:int, height:int):void
		{
			var g:Graphics = graphics;
			g.beginBitmapFill(_bitmapData);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		private function redraw(width:Number, height:Number):void
		{
			var g:Graphics = graphics;
			g.clear();
			Scale9GridDrawer.Draw(g, _bitmapData, 0, 0, width, height, scale9Grid);
		}
		
		override public function set width(value:Number):void
		{
			redraw(value, height);
		}
		
		override public function set height(value:Number):void
		{
			redraw(width, value);
		}
		
		override public function get scale9Grid():Rectangle
		{
			return _scale9Grid.clone();
		}
		
		override public function set scale9Grid(value:Rectangle):void
		{
			_scale9Grid = value;
		}
	}
}