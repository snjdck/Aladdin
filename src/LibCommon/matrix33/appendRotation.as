package matrix33
{
	import flash.geom.Matrix;

	public function appendRotation(matrix:Matrix, angle:Number):void
	{
		var sin:Number = Math.sin(angle);
		var cos:Number = Math.cos(angle);
		
		var a:Number    = matrix.a;
		var b:Number    = matrix.b;
		var c:Number    = matrix.c;
		var d:Number    = matrix.d;
		var tx:Number   = matrix.tx;
		var ty:Number   = matrix.ty;
		
		matrix.a  = a  * cos - b  * sin;
		matrix.c  = c  * cos - d  * sin;
		matrix.tx = tx * cos - ty * sin;
		
		matrix.b  = a  * sin + b  * cos;
		matrix.d  = c  * sin + d  * cos;
		matrix.ty = tx * sin + ty * cos;
	}
}