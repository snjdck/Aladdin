package matrix33
{
	import flash.geom.Matrix;

	public function concat(left:Matrix, right:Matrix, output:Matrix):void
	{
		var a1:Number    = left.a;
		var b1:Number    = left.b;
		var c1:Number    = left.c;
		var d1:Number    = left.d;
		var tx1:Number   = left.tx;
		var ty1:Number   = left.ty;
		
		var a2:Number    = right.a;
		var b2:Number    = right.b;
		var c2:Number    = right.c;
		var d2:Number    = right.d;
		var tx2:Number   = right.tx;
		var ty2:Number   = right.ty;
		
		output.a	= a1 * a2 + b1 * c2;
		output.b	= a1 * b2 + b1 * d2;
		
		output.c	= c1 * a2 + d1 * c2;
		output.d	= c1 * b2 + d1 * d2;
		
		output.tx	= tx1 * a2 + ty1 * c2 + tx2;
		output.ty	= tx1 * b2 + ty1 * d2 + ty2;
	}
}