package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix;

	public class MatrixStack2D
	{
		private var matrixStack:Vector.<Matrix>;
		private var matrixIndex:int;
		
		public function MatrixStack2D()
		{
			matrixStack = new Vector.<Matrix>();
			matrixIndex = -1;
		}
		
		public function pushMatrix(matrix:Matrix):void
		{
			++matrixIndex;
			if(matrixStack.length <= matrixIndex){
				matrixStack.push(new Matrix());
			}
			worldMatrix.copyFrom(matrix);
			if(matrixIndex > 0){
				worldMatrix.concat(matrixStack[matrixIndex-1]);
			}
		}
		
		public function popMatrix():void
		{
			--matrixIndex;
		}
		
		public function get worldMatrix():Matrix
		{
			return matrixStack[matrixIndex];
		}
	}
}