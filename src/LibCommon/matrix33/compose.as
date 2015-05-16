package matrix33
{
	import flash.geom.Matrix;

	/**
	 * 1.缩放
	 * 2.旋转
	 * 3.位移
	 */
	internal function compose(matrix:Matrix, scaleX:Number, scaleY:Number, rotation:Number=0, tx:Number=0, ty:Number=0, isScaleFirst:Boolean=true):void
	{
		matrix.tx = tx;
		matrix.ty = ty;
		
		if(0 == rotation)
		{
			matrix.a = scaleX;
			matrix.d = scaleY;
			matrix.b = 0;
			matrix.c = 0;
			return;
		}
		
		var cos:Number = Math.cos(rotation);
		var sin:Number = Math.sin(rotation);
		
		matrix.a = scaleX * cos;
		matrix.d = scaleY * cos;
		
//		if(isScaleFirst)
//		{
			matrix.b = scaleX * sin;
			matrix.c = scaleY * -sin;
//		}
//		else//rotation first
//		{
//			matrix.b = scaleY * sin;
//			matrix.c = scaleX * -sin;
//		}
	}
}