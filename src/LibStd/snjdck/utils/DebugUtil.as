package snjdck.utils
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import stdlib.graphics.Graphics2D;
	import stdlib.graphics.path.Path;
	import stdlib.graphics.path.RectPath;
	import stdlib.graphics.pen.SolidPen;

	public class DebugUtil
	{
		static private const SIZE:int = 100;
		
		static public function DrawBorder(target:Sprite):void
		{
			var g:Graphics2D = new Graphics2D(target.graphics);
			
			DrawGrid(g);
			
			g.setPen(new SolidPen(0, 0xFF0000, 0.8));
			
			var rect:Rectangle = target.getRect(target);
			g.drawPath(new RectPath(rect.x, rect.y, rect.width, rect.height));
		}
		
		static private function DrawGrid(g:Graphics2D):void
		{
			var path:Path = new Path();
			
			for(var i:int=-SIZE; i<=SIZE; i+=10){
				path.drawVerticalLine(i, -SIZE, SIZE);
				path.drawHorizontalLine(i, -SIZE, SIZE);
			}
			
			g.setPen(new SolidPen(0, 0x00, 0.2));
			g.drawPath(path);
			
			path.clear();
			path.drawVerticalLine(0, -SIZE, SIZE);
			path.drawHorizontalLine(0, -SIZE, SIZE);
			
			g.setPen(new SolidPen(2, 0xFF00));
			g.drawPath(path);
		}
	}
}