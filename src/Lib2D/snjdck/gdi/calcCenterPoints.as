package snjdck.gdi
{
	public function calcCenterPoints(pointList:Array):Array
	{
		const n:int = pointList.length - 1;
		var result:Array = [];
		for(var i:int=0; i<n; i++){
			result.push(calcCenterPoint(pointList[i], pointList[i+1]));
		}
		return result;
	}
}