package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public function drawLine(g:Graphics, from:Point, to:Point):void
	{
		moveTo(g, from);
		lineTo(g, to);
	}
}