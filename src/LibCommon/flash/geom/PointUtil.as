package flash.geom
{
	final public class PointUtil
	{
		static public function Length(pt:Point):Number
		{
			return Math.sqrt(LengthSQ(pt));
		}
		
		static public function LengthSQ(pt:Point):Number
		{
			return (pt.x * pt.x) + (pt.y * pt.y);
		}
	}
}