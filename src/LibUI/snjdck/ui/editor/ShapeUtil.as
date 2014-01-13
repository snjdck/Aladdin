package snjdck.ui.editor
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	final internal class ShapeUtil
	{
		static public function createRect(size:Number, color:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			
			var g:Graphics = sp.graphics;
			g.lineStyle(0, color);
			g.beginFill(0, 0);
			
			var halfSize:Number = 0.5 * size;
			g.drawRect(-halfSize, -halfSize, size, size);
			
			return sp;
		}
		
		static public function createCircle(size:Number, color:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			
			var g:Graphics = sp.graphics;
			g.lineStyle(0, color);
			g.beginFill(0, 0);
			
			var halfSize:Number = 0.5 * size;
			g.drawCircle(0, 0, halfSize);
			
			return sp;
		}
	}
}