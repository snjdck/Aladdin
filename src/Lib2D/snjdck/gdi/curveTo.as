package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public function curveTo(g:Graphics, control:Point, anchor:Point):void
	{
		g.curveTo(control.x, control.y, anchor.x, anchor.y);
	}
}