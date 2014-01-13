package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;

	public function drawRect(g:Graphics, rect:Rectangle):void
	{
		g.drawRect(rect.x, rect.y, rect.width, rect.height);
	}
}