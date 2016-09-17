package flash.geom.d3
{
	public function extendQuadListIndices(quadCountNow:int, quadCountSet:int, result:Object):void
	{
		var offset:int = quadCountNow * 6;
		for(var i:int=quadCountNow; i<quadCountSet; ++i){
			var index:int = i << 2;
			result[offset++] = index;
			result[offset++] = index + 1;
			result[offset++] = index + 3;
			result[offset++] = index;
			result[offset++] = index + 3;
			result[offset++] = index + 2;
		}
	}
}