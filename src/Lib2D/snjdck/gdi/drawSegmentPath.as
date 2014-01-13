package snjdck.gdi
{
	import flash.display.Graphics;
	
	/**
	 * @param pointList Array or Vector
	 */
	public function drawSegmentPath(g:Graphics, pointList:Object):void
	{
		const n:int = pointList.length;
		
		if(n < 2){
			return;
		}
		
		moveTo(g, pointList[0]);
		for(var i:int=1; i<n; i++){
			lineTo(g, pointList[i]);
		}
	}
}