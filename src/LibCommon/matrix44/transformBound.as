package matrix44
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.bound.AABB;

	public function transformBound(matrix:Matrix3D, source:AABB, result:AABB):void
	{
		var sourceMinX:Number = source.minX;
		var sourceMaxX:Number = source.maxX;
		var sourceMinY:Number = source.minY;
		var sourceMaxY:Number = source.maxY;
		var sourceMinZ:Number = source.minZ;
		var sourceMaxZ:Number = source.maxZ;
		
		var rawData:Vector.<Number> = matrix.rawData;
		var minX:Number = rawData[12], maxX:Number = minX;
		var minY:Number = rawData[13], maxY:Number = minY;
		var minZ:Number = rawData[14], maxZ:Number = minZ;
		var factor:Number;
		
		if((factor = rawData[0]) > 0){
			minX += factor * sourceMinX;
			maxX += factor * sourceMaxX;
		}else{
			minX += factor * sourceMaxX;
			maxX += factor * sourceMinX;
		}
		if((factor = rawData[4]) > 0){
			minX += factor * sourceMinY;
			maxX += factor * sourceMaxY;
		}else{
			minX += factor * sourceMaxY;
			maxX += factor * sourceMinY;
		}
		if((factor = rawData[8]) > 0){
			minX += factor * sourceMinZ;
			maxX += factor * sourceMaxZ;
		}else{
			minX += factor * sourceMaxZ;
			maxX += factor * sourceMinZ;
		}
		if((factor = rawData[1]) > 0){
			minY += factor * sourceMinX;
			maxY += factor * sourceMaxX;
		}else{
			minY += factor * sourceMaxX;
			maxY += factor * sourceMinX;
		}
		if((factor = rawData[5]) > 0){
			minY += factor * sourceMinY;
			maxY += factor * sourceMaxY;
		}else{
			minY += factor * sourceMaxY;
			maxY += factor * sourceMinY;
		}
		if((factor = rawData[9]) > 0){
			minY += factor * sourceMinZ;
			maxY += factor * sourceMaxZ;
		}else{
			minY += factor * sourceMaxZ;
			maxY += factor * sourceMinZ;
		}
		if((factor = rawData[2]) > 0){
			minZ += factor * sourceMinX;
			maxZ += factor * sourceMaxX;
		}else{
			minZ += factor * sourceMaxX;
			maxZ += factor * sourceMinX;
		}
		if((factor = rawData[6]) > 0){
			minZ += factor * sourceMinY;
			maxZ += factor * sourceMaxY;
		}else{
			minZ += factor * sourceMaxY;
			maxZ += factor * sourceMinY;
		}
		if((factor = rawData[10]) > 0){
			minZ += factor * sourceMinZ;
			maxZ += factor * sourceMaxZ;
		}else{
			minZ += factor * sourceMaxZ;
			maxZ += factor * sourceMinZ;
		}
		
		result.setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
	}
}