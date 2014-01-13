package stdlib
{
	import flash.geom.Point;
	
	/**
	 * (ab) x (ac) = (ab.x) x (ac.y) - (ac.x) x (ab.y)
	 */
	public function geom_multi(a:Point, b:Point, c:Point):Number
	{
		return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
	}
}