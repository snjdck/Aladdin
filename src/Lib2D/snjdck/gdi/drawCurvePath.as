package snjdck.gdi
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public function drawCurvePath(g:Graphics, pointList:Array):void
	{	
		if(pointList.length < 3){
			return;
		}
		
		const centerPoints:Array = calcCenterPoints(pointList);
		const n:int = centerPoints.length;
		
		drawLine(g, pointList[0], centerPoints[0]);
		for(var i:int=1; i < n; i++){
			curveTo(g, pointList[i], centerPoints[i]);
		}
		lineTo(g, pointList[n]);
	}
}