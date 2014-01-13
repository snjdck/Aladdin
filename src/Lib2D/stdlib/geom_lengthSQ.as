package stdlib
{
	import flash.geom.Point;

	public function geom_lengthSQ(pt:Point):Number
	{
		return (pt.x * pt.x) + (pt.y * pt.y);
	}
}