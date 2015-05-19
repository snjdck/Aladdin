package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	public function decompose(matrix:Matrix, offset:Point, scale:Point, rot:Point):void
	{
		offset.x = matrix.tx;
		offset.y = matrix.ty;
		
		if(0 == matrix.c && 0 == matrix.b){//rotation == 0
			scale.x = matrix.a;
			scale.y = matrix.d;
			rot.x = 0;
			return;
		}
		
		if(0 == matrix.a && 0 == matrix.d){
			scale.x = matrix.b;
			scale.y = -matrix.c;
			rot.x = 90;
			return;
		}
		
		scale.x = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
		scale.y = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
		
		rot.x = Math.atan2(matrix.b, matrix.a);
	}
}