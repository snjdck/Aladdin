package snjdck.gdi
{
	public function calcBezierPath(pointList:Array, count:int):Array
	{
		if(pointList.length < 3){
			return pointList;
		}
		
		const centerPoints:Array = calcCenterPoints(pointList);
		const n:int = centerPoints.length;
		
		var result:Array = [pointList[0], centerPoints[0]];
		for(var i:int=1; i < n; i++){
			bezierSpline([centerPoints[i-1], pointList[i], centerPoints[i]], count, result);
		}
		result.push(pointList[n]);
		return result;
	}
}

import flash.geom.Point;

import snjdck.gdi.bezier;

function bezierSpline(controlPts:Array, count:int, result:Array):void
{
	//不包含起点,包含终点
	for (var i:int=1; i <= count; i++)
	{
		var pt:Point = new Point();
		bezier(i / count, controlPts, pt);
		result.push(pt);
	}
}