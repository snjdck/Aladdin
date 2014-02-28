package flash.geom.d2
{
	import flash.geom.Point;

	public function getProjectPtOnLine(pt:Point, pa:Point, pb:Point):Point
	{
		if (pa.x == pb.x) return new Point(pa.x, pt.y);
		if (pa.y == pb.y) return new Point(pt.x, pa.y);
		
		var k:Number = (pb.y - pa.y) / (pb.x - pa.x);
		var projectX:Number = pa.x + (k * (pt.y - pa.y) + pt.x - pa.x) / (k * k + 1);
		var projectY:Number = pa.y + k * (projectX - pa.x);
		
		return new Point(projectX, projectY);
	}
}