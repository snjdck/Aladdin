package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public function transformBound(matrix:Matrix, source:Rectangle, result:Rectangle):void
	{
		var left:Number = source.x;
		var right:Number = source.x + source.width;
		var top:Number = source.y;
		var bottom:Number = source.y + source.height;
		
		var minX:Number = matrix.tx, maxX:Number = minX;
		var minY:Number = matrix.ty, maxY:Number = minY;
		var factor:Number;
		
		factor = matrix.a;
		if(factor > 0){
			minX += factor * left;
			maxX += factor * right;
		}else{
			minX += factor * right;
			maxX += factor * left;
		}
		factor = matrix.c;
		if(factor > 0){
			minX += factor * top;
			maxX += factor * bottom;
		}else{
			minX += factor * bottom;
			maxX += factor * top;
		}
		factor = matrix.b;
		if(factor > 0){
			minY += factor * left;
			maxY += factor * right;
		}else{
			minY += factor * right;
			maxY += factor * left;
		}
		factor = matrix.d;
		if(factor > 0){
			minY += factor * top;
			maxY += factor * bottom;
		}else{
			minY += factor * bottom;
			maxY += factor * top;
		}
		result.x = minX;
		result.y = minY;
		result.width = maxX - minX;
		result.height = maxY - minY;
	}
}