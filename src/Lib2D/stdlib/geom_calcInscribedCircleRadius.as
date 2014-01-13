package stdlib
{
	import flash.geom.Point;

	public function geom_calcInscribedCircleRadius(a:Point, b:Point, c:Point):Number
	{
		var da:Number = geom_distance(a, b);
		var db:Number = geom_distance(b, c);
		var dc:Number = geom_distance(c, a);
		return (2 * geom_calcTriangleArea(a, b, c)) / (da + db + dc);
	}
}