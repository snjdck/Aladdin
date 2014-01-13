package snjdck.ai.navmesh.test
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import snjdck.ai.astar.AStar;
	import snjdck.ai.navmesh.Delaunay;
	import snjdck.ai.navmesh.Edge;
	import snjdck.ai.navmesh.ScanArea;
	import snjdck.ai.navmesh.TriAstarNode;
	import snjdck.ai.navmesh.Triangle;
	
	public class TestNavMesh extends Sprite
	{
		private var pts:Vector.<Point> = new Vector.<Point>();
		private var inner:Vector.<Point> = new Vector.<Point>();
		
		private var isKeyDown:Boolean;
		private var isMapBuilded:Boolean;
		
		private var triList:Vector.<Triangle>;
		private var astarTriList:Vector.<TriAstarNode>;
		
		private var ptStart:Point;
		private var ptEnd:Point;
		
		private var pathLayer:Shape = new Shape();
		
		public function TestNavMesh()
		{
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.CLICK, __onClick);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, __onDoubleclick);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
			addChild(pathLayer);
		}
		
		protected function __onKeyDown(event:KeyboardEvent):void
		{
			isKeyDown = true;
		}
		
		protected function __onKeyUp(event:KeyboardEvent):void
		{
			isKeyDown = false;
		}
		
		private function __onDoubleclick(event:MouseEvent):void
		{
			if(isMapBuilded){
				return;
			}
			
			graphics.clear();
			var contpts:Vector.<Point> = inner;
//			pts = new <Point>[new Point(10, 10), new Point(400, 40), new Point(400, 160), new Point(40, 370)];
			contpts = parseVectorPoints(
				"162,173 178,199 225,184 257,178 269,197 275,227 272,248 253,252 230,237 231,213 201,213 191,231 204,252 225,274 188,274 162,253 164,224 143,224 123,233 106,224",
				0, 0, ' ', ','
			);
			contpts.push(contpts[0]);
//			var bound:Vector.<Point> = Bound.findBoundary(pts);
//			DebugDrawer.drawDots(graphics, pts);
//			DebugDrawer.drawPts(graphics, contpts);
//			return;
//			drawEdges(Delaunay.buildEdgeList(bound), 0x000000, 2);
			
//			var cdt:Vector.<Point> = new <Point>[new Point(100, 100), new Point(200, 100)];
//			var ret:Array = Delaunay.buildTri(pts, contpts);
			triList = Delaunay.buildTri(pts, contpts);
			mapToAstarNode();
			
			trace("pt count", pts.length);
			trace("tri count", triList.length);
			DebugDrawer.drawTris(graphics, triList);
//			DebugDrawer.drawEdges(graphics, ret[1]);
//			DebugDrawer.drawEdges(graphics, ret[2]);
//			DebugDrawer.drawEdges(graphics, Bound.buildEdgeList(Bound.findBoundary(contpts)));
//			drawPts(cdt, 0xaaaaaa, 8);
			
			pts.length = 0;
			inner.length = 0;
			isMapBuilded = true;
		}
		
		private function __onClick(event:MouseEvent):void
		{
			var pt:Point = new Point(stage.mouseX, stage.mouseY);
			
			if(isMapBuilded){
				if(null == ptStart){
					ptStart = pt;
				}else{
					ptEnd = pt;
					findPath();
					ptStart = null;
				}
				return;
			}
			
			if(isKeyDown){
				addPtToList(inner, pt);
			}else{
				addPtToList(pts, pt);
			}
		}
		
		private function findPath():void
		{
			var start:TriAstarNode = findTri(ptStart);
			var end:TriAstarNode = findTri(ptEnd);
			var nodeListPath:Array = AStar.FindPath(start, end);
			
			var triListPath:Vector.<Triangle> = NodeToTri(nodeListPath);
			var edgeListPath:Vector.<Edge> = getSharedEdges(triListPath);
			
			var path:Vector.<Point> = getPath(ptStart, ptEnd, edgeListPath);
			
			pathLayer.graphics.clear();
			DebugDrawer.drawTris(pathLayer.graphics, triListPath);
			DebugDrawer.drawEdges(pathLayer.graphics, edgeListPath);
			DebugDrawer.drawPts(pathLayer.graphics, path, 0xFF0000);
		}
		
		static private function addPtToList(list:Vector.<Point>, pt:Point):void
		{
			for each(var testPt:Point in list){
				if(testPt.equals(pt)){
					return;
				}
			}
			list.push(pt);
		}
		
		public function findTri(pt:Point):TriAstarNode
		{
			for each(var node:TriAstarNode in astarTriList){
				if(node.tri.isPtIn(pt) <= 0){
					return node;
				}
			}
			return null;
		}
		
		public function mapToAstarNode():void
		{
			astarTriList = new Vector.<TriAstarNode>();
			for each(var tri:Triangle in triList){
				astarTriList.push(new TriAstarNode(tri, astarTriList));
			}
		}
		
		static private function getSharedEdges(triList:Vector.<Triangle>):Vector.<Edge>
		{
			var edgeList:Vector.<Edge> = new Vector.<Edge>();
			for(var i:int=0; i<triList.length-1; ++i)
			{
				var edge:Edge = triList[i].getSharedEdge(triList[i+1]);
				edgeList.push(edge);
			}
			return edgeList;
			
		}
		
		static public function NodeToTri(nodes:Object):Vector.<Triangle>
		{
			var result:Vector.<Triangle> = new Vector.<Triangle>();
			for each(var node:TriAstarNode in nodes){
				result.push(node.tri);
			}
			return result;
		}
	
		static public function getPath(start:Point, end:Point, edgeList:Vector.<Edge>):Vector.<Point>
		{
			var area:ScanArea = new ScanArea();
			var path:Vector.<Point> = area.scanList(start, end, edgeList);
			if(null == path){
				return null;
			}
			return path;
		}
		
		static public function parseVectorPoints(
			str:String, dx:Number = 0.0,
			dy:Number = 0.0,
			pointsSeparator:String = ',',
			componentSeparator:String = ' '
		):Vector.<flash.geom.Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			for each (var xy_str:String in str.split(pointsSeparator)) {
				var xyl:Array = xy_str.replace(/^\s+/, '').replace(/\s+$/, '').split(componentSeparator);
				points.push(new Point(parseFloat(xyl[0]) + dx, parseFloat(xyl[1]) + dy));
			}
			return points;
		}
	}
}