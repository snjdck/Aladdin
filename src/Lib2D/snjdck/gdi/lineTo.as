package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public function lineTo(g:Graphics, pt:Point):void
	{
		g.lineTo(pt.x, pt.y);
	}
}