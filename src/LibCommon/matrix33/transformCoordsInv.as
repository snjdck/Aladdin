package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	public function transformCoordsInv(matrix:Matrix, x:Number, y:Number, output:Point):void
	{
		var a:Number    = matrix.a;
		var b:Number    = matrix.b;
		var c:Number    = matrix.c;
		var d:Number    = matrix.d;
		var tx:Number   = matrix.tx;
		var ty:Number   = matrix.ty;
		
		var factor:Number = a * d - b * c;
		
		if(0 == factor){
			output.x = x;
			output.y = y;
			return;
		}
		
		if(0 == c && 0 == b){//rotation == 0
			output.x = (x - tx) / a;
			output.y = (y - ty) / d;
			return;
		}
		
		var dx:Number = x - tx;
		var dy:Number = y - ty;
		
		factor = 1 / factor;
		
		output.x = factor * (d * dx - c * dy);
		output.y = factor * (a * dy - b * dx);
	}
}