package snjdck.ai.navmesh
{
	import flash.geom.Point;
	
	import vec2.dotProd;

	final public class Bound
	{
		static public function buildEdgeList(pointList:Vector.<Point>):Vector.<Edge>
		{
			var result:Vector.<Edge> = new Vector.<Edge>();
			for(var i:int=0; i<pointList.length-1; ++i){
				result.push(new Edge(pointList[i], pointList[i+1]));
			}
			return result;
		}
		
		static public function findBoundary(pointList:Vector.<Point>):Vector.<Point>
		{
			var firstPt:Point = findTopLeftPt(pointList);
			var currPt:Point = firstPt;
			
			var edgeList:Vector.<Point> = new <Point>[firstPt];
			var vec1:Point = new Point(0, -1);
			
			while(true)
			{
				var bestPt:Point = getBestPt(currPt, vec1, pointList);
				edgeList.push(bestPt);
				
				if (bestPt == firstPt) break;
				
				vec1 = currPt.subtract(bestPt);
				currPt = bestPt;
			}
			
			return edgeList;
		}
		
		static private function getBestPt(currPt:Point, vecA:Point, pointList:Vector.<Point>):Point
		{
			var vecALen:Number = vecA.length;
			var angleMax:Number = -1;
			var lengthMin:Number = Number.MAX_VALUE;
			var bestPt:Point = null;
			
			for each(var tempPt:Point in pointList)
			{
				if (tempPt == currPt) continue;
				
				var vecB:Point = tempPt.subtract(currPt);
				var vecBLen:Number = vecB.length;
				var angleTemp:Number = - dotProd(vecA, vecB) / (vecALen * vecBLen);
				
				if (angleTemp < angleMax) continue;
				
				if(angleTemp > angleMax || vecBLen < lengthMin){
					angleMax = angleTemp;
					lengthMin = vecBLen;
					bestPt = tempPt;
				}
			}
			
			return bestPt;
		}
		
		static private function findTopLeftPt(pointList:Vector.<Point>):Point
		{
			var minX:Number = Number.MAX_VALUE;
			var target:Point = null;
			
			for each(var tempPt:Point in pointList){
				if(tempPt.x < minX){
					minX = tempPt.x;
					target = tempPt;
				}
			}
			
			return target;
		}
	}
}