package stdlib
{
	import flash.geom.Point;

	/**
	 * 2R = c / sinC
	 * S = 0.5 * ab * sinC
	 * =>
	 * R = abc / (4S)
	 */
	public function geom_calcCircumcircleRadius(a:Point, b:Point, c:Point):Number
	{
		var da:Number = geom_distance(a, b);
		var db:Number = geom_distance(b, c);
		var dc:Number = geom_distance(c, a);
		return (da * db * dc) / (4 * geom_calcTriangleArea(a, b, c));
	}
}