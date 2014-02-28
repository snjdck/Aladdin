package snjdck.ai.navmesh
{
	import flash.geom.Point;
	
	import flash.geom.d2.JudgeLineToLine;
	import flash.geom.d2.JudgePtToCircle;
	import flash.geom.d2.JudgePtToLine;

	/**
	 * 最小内角优先原则 三角化 凹多边形
	 */
	final public class Delaunay
	{
		static public function buildTri(pointList:Vector.<Point>, constraint:Vector.<Point>=null):Vector.<Triangle>
		{
			var bound1:Vector.<Point> = Bound.findBoundary(pointList);
			var bound2:Vector.<Point> = constraint;
//			var bound2:Vector.<Point> = Bound.findBoundary(constraint).reverse();
			
			var totalPts:Vector.<Point> = bound1.concat(bound2);
			
			var edgeList:Vector.<Edge> = Bound.buildEdgeList(bound1);
			var constraintEdgeList:Vector.<Edge> = Bound.buildEdgeList(bound2);
			
			var totalEdges:Vector.<Edge> = edgeList.concat(constraintEdgeList);
			
			var triList:Vector.<Triangle> = new Vector.<Triangle>();
			
			initTriMeshConst(totalPts, totalEdges, triList);
			linkTriMesh(totalEdges);
			
			return triList;
		}
		
		static private function initTriMeshConst(pointList:Vector.<Point>, edgeList:Vector.<Edge>, triList:Vector.<Triangle>):void
		{
			for(var i:int=0; i<edgeList.length; ++i)
			{
				var bc:Edge = edgeList[i];
				
				if(bc.leftTri){
					continue;
				}
				
				var pt:Point = findDT(pointList, edgeList, bc);
				
				var newTri:Triangle = new Triangle(pt, bc.start, bc.end);
				triList.push(newTri);
				
				var ba:Edge = findOrCreateEdge(edgeList, bc.start, pt);
				var ac:Edge = findOrCreateEdge(edgeList, pt, bc.end);
				
				newTri.edgeA = bc;
				newTri.edgeB = ac;
				newTri.edgeC = ba;
				
				ba.setRightTri(bc.start, pt, newTri);
				ac.setRightTri(pt, bc.end, newTri);
				bc.leftTri = newTri;
			}
		}
		
		static private function linkTriMesh(edgeList:Vector.<Edge>):void
		{
			for each(var edge:Edge in edgeList){
				if(edge.leftTri && edge.rightTri){
					edge.leftTri.setNeighbour(edge, edge.rightTri);
					edge.rightTri.setNeighbour(edge, edge.leftTri);
				}
			}
		}
		
		/**
		 * 点在edge的左边
		 * 点不跟其它边相交
		 * 外接圆不包含其它点
		 */		
		static private function findDT(pointList:Vector.<Point>, edgeList:Vector.<Edge>, edge:Edge):Point
		{
			var pts:Vector.<Point> = getPtList(pointList, edge);
			for each(var pt:Point in pts){
				if(isInCircle(edge.start, edge.end, pt, pts)){
					continue;
				}
				if(isInterAnother(edge.start, pt, edgeList)){
					continue;
				}
				if(isInterAnother(edge.end, pt, edgeList)){
					continue;
				}
				return pt;
			}
			return null;
		}
		
		static private function getPtList(pointList:Vector.<Point>, edge:Edge):Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			for each(var pt:Point in pointList){
				if(JudgePtToLine.Judge(edge.start, edge.end, pt) != JudgePtToLine.LEFT_SIDE){
					continue;
				}
				result.push(pt);
			}
			return result;
		}
		
		static private function isInCircle(pa:Point, pb:Point, pc:Point, pointList:Vector.<Point>):Boolean
		{
			for each(var pt:Point in pointList){
				if(JudgePtToCircle.Judge(pa, pb, pc, pt) == JudgePtToCircle.INSIDE){
					return true;
				}
			}
			return false;
		}
		
		static private function isInterAnother(pa:Point, pb:Point, edgeList:Vector.<Edge>):Boolean
		{
			var crossPt:Point = new Point();
			for each(var tempEdge:Edge in edgeList){
				if(JudgeLineToLine.Judge(pa, pb, tempEdge.start, tempEdge.end, crossPt) != JudgeLineToLine.SEGMENTS_INTERSECT){
					continue;
				}
				if(!(crossPt.equals(pa) || crossPt.equals(pb))){
					return true;
				}
			}
			return false;
		}
		
		static private function findOrCreateEdge(edgeList:Vector.<Edge>, pa:Point, pb:Point):Edge
		{
			var edge:Edge;
			for each(edge in edgeList){
				if(edge.equalEndpoint(pa, pb)){
					return edge;
				}
			}
			edge = new Edge(pa, pb);
			edgeList.push(edge);
			return edge;
		}
	}
}