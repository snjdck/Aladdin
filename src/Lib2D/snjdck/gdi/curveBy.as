package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public function curveBy(g:Graphics, from:Point, cross:Point, to:Point):void
	{
		curveTo(g, new Point(
			cross.x * 2 - 0.5 * (from.x + to.x),
			cross.y * 2 - 0.5 * (from.y + to.y)
		), to);
	}
}