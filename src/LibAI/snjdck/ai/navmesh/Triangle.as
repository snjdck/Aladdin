package snjdck.ai.navmesh
{
	import flash.geom.Point;
	
	import geom2d.JudgePtToCircle;
	import geom2d.JudgePtToTriangle;

	public class Triangle
	{
		public var pA:Point;
		public var pB:Point;
		public var pC:Point;
		
		public var edgeA:Edge;
		public var edgeB:Edge;
		public var edgeC:Edge;
		
		public var triA:Triangle;
		public var triB:Triangle;
		public var triC:Triangle;
		
		public function Triangle(pA:Point=null, pB:Point=null, pC:Point=null)
		{
			this.pA = pA;
			this.pB = pB;
			this.pC = pC;
		}
		
		public function getAnotherPt(edge:Edge):Point
		{
			switch(true)
			{
				case edge.equalEndpoint(pA, pB):
					return pC;
				case edge.equalEndpoint(pA, pC):
					return pB;
				case edge.equalEndpoint(pB, pC):
					return pA;
			}
			return null;
		}
		
		public function isPtInCircle(pt:Point):int
		{
			return JudgePtToCircle.Judge(pA, pB, pC, pt);
		}
		
		public function isPtIn(pt:Point):int
		{
			return JudgePtToTriangle.Judge(pt, pA, pB, pC);
		}
		
		public function setNeighbour(edge:Edge, tri:Triangle):void
		{
			switch(true)
			{
				case edge.equalEndpoint(pA, pB):
					triC = tri;
					break;
				case edge.equalEndpoint(pA, pC):
					triB = tri;
					break;
				case edge.equalEndpoint(pB, pC):
					triA = tri;
					break;
			}
		}
		
		public function getCenterX():Number
		{
			return (pA.x + pB.x + pC.x) / 3;
		}
		
		public function getCenterY():Number
		{
			return (pA.y + pB.y + pC.y) / 3;
		}
		
		public function getSharedEdge(other:Triangle):Edge
		{
			switch(other)
			{
				case edgeA.leftTri:
				case edgeA.rightTri:
					return edgeA;
				case edgeB.leftTri:
				case edgeB.rightTri:
					return edgeB;
				case edgeC.leftTri:
				case edgeC.rightTri:
					return edgeC;
			}
			return null;
		}
	}
}