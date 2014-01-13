package stdlib
{
	import flash.geom.Point;

	public function geom_calcTriangleArea(a:Point, b:Point, c:Point):Number
	{
		return 0.5 * Math.abs(geom_multi(a, b, c));
	}
}