package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public function transformBound(matrix:Matrix, source:Rectangle, result:Rectangle):void
	{
		var sourceMinX:Number = source.x;
		var sourceMaxX:Number = source.x + source.width;
		var sourceMinY:Number = source.y;
		var sourceMaxY:Number = source.y + source.height;
		
		var minX:Number = matrix.tx, maxX:Number = minX;
		var minY:Number = matrix.ty, maxY:Number = minY;
		var factor:Number;
		
		if((factor = matrix.a) > 0){
			minX += factor * sourceMinX;
			maxX += factor * sourceMaxX;
		}else{
			minX += factor * sourceMaxX;
			maxX += factor * sourceMinX;
		}
		if((factor = matrix.c) > 0){
			minX += factor * sourceMinY;
			maxX += factor * sourceMaxY;
		}else{
			minX += factor * sourceMaxY;
			maxX += factor * sourceMinY;
		}
		if((factor = matrix.b) > 0){
			minY += factor * sourceMinX;
			maxY += factor * sourceMaxX;
		}else{
			minY += factor * sourceMaxX;
			maxY += factor * sourceMinX;
		}
		if((factor = matrix.d) > 0){
			minY += factor * sourceMinY;
			maxY += factor * sourceMaxY;
		}else{
			minY += factor * sourceMaxY;
			maxY += factor * sourceMinY;
		}
		
		result.x = minX;
		result.y = minY;
		result.width  = maxX - minX;
		result.height = maxY - minY;
	}
}