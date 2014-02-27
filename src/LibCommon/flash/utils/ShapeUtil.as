package flash.utils
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	final public class ShapeUtil
	{
		static public function CreateBox(width:Number, height:Number, fillColor:uint=0xFF0000FF, borderColor:uint=0xFFFFFFFF):Sprite
		{
			var sp:Sprite = new Sprite();
			
			var g:Graphics = sp.graphics;
			g.lineStyle(1, borderColor & 0xFFFFFF, (borderColor >>> 24)/0xFF);
			g.beginFill(fillColor & 0xFFFFFF, (fillColor >>> 24)/0xFF);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			return sp;
		}
		
		static public function CreateRect(size:Number, color:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			
			var g:Graphics = sp.graphics;
			g.lineStyle(0, color);
			g.beginFill(0, 0);
			
			var halfSize:Number = 0.5 * size;
			g.drawRect(-halfSize, -halfSize, size, size);
			
			return sp;
		}
		
		static public function CreateCircle(size:Number, color:uint):Sprite
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