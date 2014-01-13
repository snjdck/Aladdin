package geom2d
{
	import flash.geom.Point;
	
	import vec2.crossProd;

	final public class JudgeLineToLine
	{
		/** lines intersect, but their segments do not */
		static public const LINES_INTERSECT		:int = 0x01;
		
		/** both line segments bisect each other */
		static public const SEGMENTS_INTERSECT	:int = 0x02;
		
		/** line segment B is crossed by line A */
		static public const A_BISECTS_B			:int = 0x04;
		
		/** line segment A is crossed by line B */
		static public const B_BISECTS_A			:int = 0x08;
		
		/** the lines are paralell */
		static public const PARALELL			:int = 0x10;
		
		/** both lines are parallel and overlap each other */
		static public const COLLINEAR			:int = 0x20;
		
		/**
		 * @param pa line1A
		 * @param pb line1B
		 * @param pc line2A
		 * @param pd line2B
		 * @param outputIntersectPoint 交点(如果有)
		 * @return see class const of this
		 */		
		static public function Judge(pa:Point, pb:Point, pc:Point, pd:Point, outputIntersectPoint:Point=null):int
		{
			var ab:Point = pb.subtract(pa);
			var cd:Point = pd.subtract(pc);
			var ac:Point = pc.subtract(pa);
			
			var denom:Number = crossProd(ab, cd);
			var u0:Number = crossProd(ac, cd);
			var u1:Number = crossProd(ac, ab);
			
			if(0 == denom){
				if(0 == u0 && 0 == u1){
					return COLLINEAR;
				}
				return PARALELL;
			}
			
			/** |ap| / |ab| */
			u0 /= denom;
			
			/** |cp| / |cd| */
			u1 /= denom;
			
			var x:Number = pa.x + u0 * ab.x;
			var y:Number = pa.y + u0 * ab.y;
			
			if(null != outputIntersectPoint){
				outputIntersectPoint.x = x;
				outputIntersectPoint.y = y;
			}
			
			var isU0Valid:Boolean = (0 <= u0 && u0 <= 1);
			var isU1Valid:Boolean = (0 <= u1 && u1 <= 1);
			
			if(isU0Valid && isU1Valid){
				return SEGMENTS_INTERSECT;
			}
			
			if (isU1Valid) return A_BISECTS_B;
			if (isU0Valid) return B_BISECTS_A;
			
			return LINES_INTERSECT;
		}
	}
}