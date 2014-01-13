package vec2
{
	import flash.geom.Point;

	[Inline]
	public function dotProd(va:Point, vb:Point):Number
	{
		return (va.x * vb.x) + (va.y * vb.y);
	}
}