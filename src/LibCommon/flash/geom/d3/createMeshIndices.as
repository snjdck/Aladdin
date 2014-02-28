package flash.geom.d3
{
	public function createMeshIndices(numVertexPerRow:int, numVertexPerCol:int, result:Object):void
	{
		var numGridPerRow:uint = numVertexPerRow - 1;
		var numGridPerCol:uint = numVertexPerCol - 1;
		
		for(var row:int=0; row<numGridPerCol; row++)
		{
			for(var col:int=0; col<numGridPerRow; col++)
			{
				var a:int = col + numVertexPerRow * row;
				var b:int = col + numVertexPerRow * (row + 1);
				//三角形1, 三角形2
				result.push(a, a+1, b+1, a, b+1, b);
			}
		}
	}
}