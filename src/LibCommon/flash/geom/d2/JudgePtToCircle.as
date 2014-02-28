package flash.geom.d2
{
	import flash.geom.Point;
	
	import math.nearEquals;
	
	import vec2.crossProd;
	import vec2.dotProd;

	final public class JudgePtToCircle
	{
		static public const INSIDE	:int = -1;
		static public const CROSS	:int = 0;
		static public const OUTSIDE	:int = 1;
		
		static public function Judge(pa:Point, pb:Point, pc:Point, pd:Point):int
		{
			var ac:Point = pc.subtract(pa);
			var dc:Point = pc.subtract(pd);
			var bc:Point = pc.subtract(pb);
			
			var ab:Point = pb.subtract(pa);
			
			var det:Number = crossProd(bc, ac) * crossProd(bc, dc);
			
			if(nearEquals(det, 0)){//d在bc直线上
				var ad:Point = pd.subtract(pa);
				
				var val:Number = crossProd(ab, ad) * crossProd(ac, ad);
				if (nearEquals(val, 0)) return CROSS;
				return (val < 0) ? INSIDE : OUTSIDE;
			}
			
			var db:Point = pb.subtract(pd);
			
			var cosA:Number = dotProd(ab, ac) / (ab.length * ac.length);
			var cosD:Number = dotProd(db, dc) / (db.length * dc.length);
			
			if(det < 0){
				cosA = -cosA;
			}
			
			if (nearEquals(cosD, cosA)) return CROSS;
			return (cosD < cosA) ? INSIDE : OUTSIDE;
		}
	}
}