package flash.geom.d2
{
	import flash.geom.Point;
	
	import math.nearEquals;
	
	import vec2.crossProd;

	/**
	 * 注意坐标系问题!!!<br>
	 * 在flash坐标系下,x轴向右,y向下<br>
	 * 在logic坐标系下,x轴向右,y向上<br>
	 * <br>
	 * 假设点A(1,0), 点B(0,1)<br>
	 * cross(A,B) == 1<br>
	 * 在logic坐标系下,返回值大于0则点在线的左侧,小于0则点在线的右侧<br>
	 * 在flash坐标系下,返回值大于0则点在线的右侧,小于0则点在线的左侧<br>
	 */
	final public class JudgePtToLine
	{
		static public const LEFT_SIDE	:int = -1;
		static public const ON_LINE		:int = 0;
		static public const RIGHT_SIDE	:int = 1;
		
		/** 在flash坐标系下 */
		static public function Judge(lineA:Point, lineB:Point, pt:Point):int
		{
			var ab:Point = lineB.subtract(lineA);
			var ac:Point = pt.subtract(lineA);
			
			var ret:Number = crossProd(ab, ac);
			
			if (nearEquals(ret, 0)) return ON_LINE;
			return (ret < 0) ? LEFT_SIDE : RIGHT_SIDE;
		}
	}
}