package snjdck.gdi
{
	import flash.geom.Point;

	public function calcCenterPoint(a:Point, b:Point):Point
	{
		return new Point(0.5 * (a.x + b.x), 0.5 * (a.y + b.y));
	}
}