package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	public function decompose(matrix:Matrix, position:Vector3D, scale:Vector3D, rotation:Vector3D):void
	{
		position.x = matrix.tx;
		position.y = matrix.ty;
		
		if(0 == matrix.c && 0 == matrix.b){//rotation == 0
			scale.x = matrix.a;
			scale.y = matrix.d;
			rotation.z = 0;
			return;
		}
		
		if(0 == matrix.a && 0 == matrix.d){
			scale.x = matrix.b;
			scale.y = -matrix.c;
			rotation.z = 90;
			return;
		}
		
		scale.x = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
		scale.y = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
		
		rotation.z = Math.atan2(matrix.b, matrix.a);
	}
}