package snjdck.ai.navmesh
{
	import flash.geom.Point;
	
	import vec2.crossProd;
	
	final public class ScanArea
	{
		private var leftPt:Point;
		private var rightPt:Point;
		private var navPt:Point;
		
		public function ScanArea()
		{
		}
		
		public function scanList(start:Point, end:Point, edgeList:Vector.<Edge>):Vector.<Point>
		{
			const navList:Vector.<Point> = new Vector.<Point>();
			addNavPt(navList, start);
			
			const edgeCount:int = edgeList.length;
			var edgeIndex:int = 0;
			
			for(;;){
				for(; edgeIndex < edgeCount; ++edgeIndex){
					var corner:Point = scan(edgeList[edgeIndex]);
					if(corner != null){
						edgeIndex = getEdgeIndex(edgeList, edgeIndex, corner);
						addNavPt(navList, corner);
					}
				}
				
				if(leftPt && judge(leftPt, end) < 0){
					edgeIndex = getEdgeIndex(edgeList, edgeIndex, leftPt);
					addNavPt(navList, leftPt);
					continue;
				}
				
				if(rightPt && judge(rightPt, end) > 0){
					edgeIndex = getEdgeIndex(edgeList, edgeIndex, rightPt);
					addNavPt(navList, rightPt);
					continue;
				}
				
				break;
			}
			
			addNavPt(navList, end);
			return navList;
		}
		
		private function scan(edge:Edge):Point
		{
			if(edge.isEndpoint(navPt)){
				return null;
			}
			
			var newLeftPt:Point = edge.start;
			var newRightPt:Point = edge.end;
			
			if(judge(newLeftPt, newRightPt) < 0){
				newLeftPt = edge.end;
				newRightPt = edge.start;
			}
			
			if(!(leftPt && rightPt)){
				leftPt = newLeftPt;
				rightPt = newRightPt;
				return null;
			}
			
			if(judge(leftPt, newRightPt) <= 0){
				return leftPt;
			}
			
			if(judge(rightPt, newLeftPt) >= 0){
				return rightPt;
			}
			
			if(judge(leftPt, newLeftPt) >= 0){
				leftPt = newLeftPt;
			}
			
			if(judge(rightPt, newRightPt) <= 0){
				rightPt = newRightPt;
			}
			
			return null;
		}
		
		private function getEdgeIndex(edgeList:Vector.<Edge>, endIndex:int, pt:Point):int
		{
			for(var i:int=0; i<endIndex; ++i){
				var edge:Edge = edgeList[i];
				if(edge.isEndpoint(pt)){
					return i;
				}
			}
			return -1;
		}
		
		private function addNavPt(navList:Vector.<Point>, newNavPt:Point):void
		{
			leftPt = rightPt = null;
			navList.push(newNavPt);
			navPt = newNavPt;
		}
		
		private function judge(b:Point, c:Point):Number
		{
			var ab:Point = b.subtract(navPt);
			var ac:Point = c.subtract(navPt);
			return crossProd(ab, ac);
		}
	}
}