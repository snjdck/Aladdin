package matrix33
{
	import flash.geom.Matrix;

	public function toBuffer(matrix:Matrix, buffer:Vector.<Number>):void
	{
		buffer[0] = matrix.a;
		buffer[1] = matrix.c;
		buffer[2] = 0;
		buffer[3] = matrix.tx;
		buffer[4] = matrix.b;
		buffer[5] = matrix.d;
		buffer[6] = 0;
		buffer[7] = matrix.ty;
	}
}