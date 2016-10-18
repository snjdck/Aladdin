package snjdck.model3d
{
	import snjdck.g3d.bounds.AABB;

	public function calcVertexBound(vertexList:Vector.<Number>, outputBound:AABB, countPerElement:int=3):void
	{
		var minX:Number=Number.MAX_VALUE, maxX:Number=Number.MIN_VALUE;
		var minY:Number=Number.MAX_VALUE, maxY:Number=Number.MIN_VALUE;
		var minZ:Number=Number.MAX_VALUE, maxZ:Number=Number.MIN_VALUE;
		
		for(var i:int=0, n:int=vertexList.length; i<n; i+=countPerElement)
		{
			var vx:Number = vertexList[i];
			var vy:Number = vertexList[i+1];
			var vz:Number = vertexList[i+2];
			
			if(vx < minX)	minX = vx;
			if(vx > maxX)	maxX = vx;
			if(vy < minY)	minY = vy;
			if(vy > maxY)	maxY = vy;
			if(vz < minZ)	minZ = vz;
			if(vz > maxZ) 	maxZ = vz;
		}
		
		outputBound.setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
	}
}