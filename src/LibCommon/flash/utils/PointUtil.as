package flash.utils
{
	import flash.geom.Point;

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
		
		static public function Distance(a:Point, b:Point):Number
		{
			return Math.sqrt(DistanceSQ(a, b));
		}
		
		static public function DistanceSQ(a:Point, b:Point):Number
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			return dx * dx + dy * dy;
		}
		
		/**
		 * (ab) x (ac) = (ab.x) x (ac.y) - (ac.x) x (ab.y)
		 */
		static public function Multi(a:Point, b:Point, c:Point):Number
		{
			return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
		}
		
		static public function CalcTriArea(a:Point, b:Point, c:Point):Number
		{
			return 0.5 * Math.abs(Multi(a, b, c));
		}
		
		/**
		 * 2R = c / sinC
		 * S = 0.5 * ab * sinC
		 * =>
		 * R = abc / (4S)
		 */
		static public function CalcCircumcircleRadius(a:Point, b:Point, c:Point):Number
		{
			var da:Number = Distance(a, b);
			var db:Number = Distance(b, c);
			var dc:Number = Distance(c, a);
			return (da * db * dc) / (4 * CalcTriArea(a, b, c));
		}
		
		static public function CalcInscribedCircleRadius(a:Point, b:Point, c:Point):Number
		{
			var da:Number = Distance(a, b);
			var db:Number = Distance(b, c);
			var dc:Number = Distance(c, a);
			return (2 * CalcTriArea(a, b, c)) / (da + db + dc);
		}
		
		/**
		 * s = start
		 * e = end
		 */
		static public function IsSegmentIntersected(s1:Point, e1:Point, s2:Point, e2:Point):Boolean
		{
			if (Math.max(s1.x, e1.x) < Math.min(s2.x, e2.x)) return false;
			if (Math.max(s2.x, e2.x) < Math.min(s1.x, e1.x)) return false;
			if (Math.max(s1.y, e1.y) < Math.min(s2.y, e2.y)) return false;
			if (Math.max(s2.y, e2.y) < Math.min(s1.y, e1.y)) return false;
			if (Multi(s1, s2, e1) * Multi(s1, e1, e2) < 0) return false;
			if (Multi(s2, s1, e2) * Multi(s2, e2, e1) < 0) return false;
			return true;
		}
	}
}