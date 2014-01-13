package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public function moveTo(g:Graphics, pt:Point):void
	{
		g.moveTo(pt.x, pt.y);
	}
}