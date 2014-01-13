package stdlib
{
	import flash.geom.Point;

	/**
	 * s = start
	 * e = end
	 */
	public function geom_isSegmentIntersected(s1:Point, e1:Point, s2:Point, e2:Point):Boolean
	{
		return (Math.max(s1.x, e1.x) >= Math.min(s2.x, e2.x))
			&& (Math.max(s2.x, e2.x) >= Math.min(s1.x, e1.x))
			&& (Math.max(s1.y, e1.y) >= Math.min(s2.y, e2.y))
			&& (Math.max(s2.y, e2.y) >= Math.min(s1.y, e1.y))
			&& (geom_multi(s1, s2, e1) * geom_multi(s1, e1, e2) >= 0)
			&& (geom_multi(s2, s1, e2) * geom_multi(s2, e2, e1) >= 0);
	}
}