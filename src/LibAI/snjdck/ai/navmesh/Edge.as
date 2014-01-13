package snjdck.ai.navmesh
{
	import flash.geom.Point;

	public class Edge
	{
		public var start:Point;
		public var end:Point;
		
		public var leftTri:Triangle;
		public var rightTri:Triangle;
		
		public function Edge(start:Point=null, end:Point=null)
		{
			this.start = start;
			this.end = end;
		}
		
		public function isEndpoint(pt:Point):Boolean
		{
			return start == pt || pt == end;
		}
		
		public function equalPts(ptStart:Point, ptEnd:Point):Boolean
		{
			return start == ptStart && end == ptEnd;
		}
		
		public function equalEndpoint(pa:Point, pb:Point):Boolean
		{
			return equalPts(pa, pb) || equalPts(pb, pa);
		}
		
		public function getLeftTri(ptStart:Point, ptEnd:Point):Triangle
		{
			if(equalPts(ptStart, ptEnd)){
				return leftTri;
			}
			if(equalPts(ptEnd, ptStart)){
				return rightTri;
			}
			return null;
		}
		
		public function setLeftTri(ptStart:Point, ptEnd:Point, tri:Triangle):void
		{
			if(equalPts(ptStart, ptEnd)){
				leftTri = tri;
				return;
			}
			if(equalPts(ptEnd, ptStart)){
				rightTri = tri;
			}
		}
		
		public function getRightTri(ptStart:Point, ptEnd:Point):Triangle
		{
			return getLeftTri(ptEnd, ptStart);
		}
		
		public function setRightTri(ptStart:Point, ptEnd:Point, tri:Triangle):void
		{
			setLeftTri(ptEnd, ptStart, tri);
		}
	}
}