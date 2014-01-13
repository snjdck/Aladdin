package matrix33
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	public function toMatrix44(input:Matrix, output:Matrix3D):void
	{
		buffer[0] = input.a;
		buffer[1] = input.b;
		buffer[4] = input.c;
		buffer[5] = input.d;
		buffer[12] = input.tx;
		buffer[13] = input.ty;
		
		output.copyRawDataFrom(buffer);
	}
}

const buffer:Vector.<Number> = new <Number>[
	1, 0, 0, 0,
	0, 1, 0, 0,
	0, 0, 1, 0,
	0, 0, 0, 1
];