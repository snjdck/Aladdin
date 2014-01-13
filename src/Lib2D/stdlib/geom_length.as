package stdlib
{
	import flash.geom.Point;

	public function geom_length(pt:Point):Number
	{
		return Math.sqrt(geom_lengthSQ(pt));
	}
}