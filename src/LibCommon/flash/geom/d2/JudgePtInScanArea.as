package flash.geom.d2
{
	import flash.geom.Point;
	
	import math.nearEquals;
	
	import vec2.crossProd;

	final public class JudgePtInScanArea
	{
		static public const INSIDE	:int = -1;
		static public const CROSS	:int = 0;
		static public const OUTSIDE	:int = 1;
		
		/**
		 * 判断pd是否在射线ab和ac之间
		 */		
		static public function Judge(pa:Point, pb:Point, pc:Point, pd:Point):int
		{
			var ab:Point = pb.subtract(pa);
			var ac:Point = pc.subtract(pa);
			var ad:Point = pd.subtract(pa);
			
			var det:Number = crossProd(ab, ad) * crossProd(ac, ad);
			
			if (nearEquals(det, 0)) return CROSS;
			
			if(det < 0){
				var bc:Point = pc.subtract(pb);
				if(crossProd(bc, ac) * crossProd(bc, ad) > 0){
					return INSIDE;
				}
			}
			
			return OUTSIDE;
		}
	}
}