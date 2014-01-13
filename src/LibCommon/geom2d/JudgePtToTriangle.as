package geom2d
{
	import flash.geom.Point;
	
	import math.nearEquals;
	
	import vec2.dotProd;

	final public class JudgePtToTriangle
	{
		static public const INSIDE	:int = -1;
		static public const CROSS	:int = 0;
		static public const OUTSIDE	:int = 1;
		
		static public function Judge(pt:Point, pa:Point, pb:Point, pc:Point):int
		{
			var v0:Point = pc.subtract(pa);
			var v1:Point = pb.subtract(pa);
			var v2:Point = pt.subtract(pa);
			
			var dot00:Number = dotProd(v0, v0);
			var dot01:Number = dotProd(v0, v1);
			var dot02:Number = dotProd(v0, v2);
			var dot11:Number = dotProd(v1, v1);
			var dot12:Number = dotProd(v1, v2);
			
			var factor:Number = 1 / (dot00 * dot11 - dot01 * dot01);
			
			var u:Number = (dot11 * dot02 - dot01 * dot12) * factor;
			
			if (u < 0 || 1 < u) return OUTSIDE;
			
			var v:Number = (dot00 * dot12 - dot01 * dot02) * factor;
			
			if (v < 0 || 1 < v) return OUTSIDE;
			
			if(0 == u || 0 == v || nearEquals(u + v, 1)){
				return CROSS;
			}
			
			return (u + v < 1) ? INSIDE : OUTSIDE;
		}
	}
}