package vec2
{
	import flash.geom.Point;

	[Inline]
	public function crossProd(pa:Point, pb:Point):Number
	{
		return (pa.x * pb.y) - (pa.y * pb.x);
	}
}