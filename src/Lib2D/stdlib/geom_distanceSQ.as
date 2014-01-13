package stdlib
{
	import flash.geom.Point;

	public function geom_distanceSQ(a:Point, b:Point):Number
	{
		var dx:Number = a.x - b.x;
		var dy:Number = a.y - b.y;
		return dx * dx + dy * dy;
	}
}