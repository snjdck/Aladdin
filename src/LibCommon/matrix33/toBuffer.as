package matrix33
{
	import flash.geom.Matrix;

	public function toBuffer(matrix:Matrix, buffer:Vector.<Number>, offset:int=0):void
	{
		buffer[offset  ] = matrix.a;
		buffer[offset+1] = matrix.c;
		buffer[offset+3] = matrix.tx;
		
		buffer[offset+4] = matrix.b;
		buffer[offset+5] = matrix.d;
		buffer[offset+7] = matrix.ty;
	}
}