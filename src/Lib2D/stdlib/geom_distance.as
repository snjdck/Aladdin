package stdlib
{
	import flash.geom.Point;

	public function geom_distance(a:Point, b:Point):Number
	{
		return Math.sqrt(geom_distanceSQ(a, b));
	}
}