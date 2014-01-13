package snjdck.ai.navmesh.test
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import snjdck.gdi.drawLine;
	import snjdck.gdi.drawSegmentPath;
	import snjdck.gdi.lineTo;
	import snjdck.gdi.moveTo;
	import snjdck.ai.navmesh.Edge;
	import snjdck.ai.navmesh.Triangle;

	internal class DebugDrawer
	{
		static public function drawTris(g:Graphics, triList:Vector.<Triangle>):void
		{
			g.lineStyle(2, 0xFFFFFF);
			
			for each(var tri:Triangle in triList)
			{
				g.beginFill(0, 0.5);
				moveTo(g, tri.pA);
				lineTo(g, tri.pB);
				lineTo(g, tri.pC);
				lineTo(g, tri.pA);
				g.endFill();
			}
		}
		
		static public function drawEdges(g:Graphics, edges:Vector.<Edge>):void
		{
			g.lineStyle(2, 0xFF);
			var edge:Edge;
			
			for each(edge in edges){
				drawLine(g, edge.start, edge.end);
				var dir:Point = edge.end.subtract(edge.start);
				drawLine(g, Point.interpolate(edge.start, edge.end, 0.9), edge.end);
			}
			
			g.lineStyle(4, 0xFF00);
			
			for each(edge in edges){
				drawLine(g, Point.interpolate(edge.start, edge.end, 0.1), edge.end);
			}
		}
		
		static public function drawDots(g:Graphics, pts:Vector.<Point>):void
		{
			g.lineStyle();
			
			for each(var pt:Point in pts){
				g.beginFill(0xDDDDDD);
				g.drawCircle(pt.x, pt.y, 10);
				g.endFill();
			}
		}
		
		static public function drawPts(g:Graphics, pts:Vector.<Point>, color:uint=0xAAAAAA):void
		{
			g.lineStyle(2, color);
			drawSegmentPath(g, pts);
		}
	}
}