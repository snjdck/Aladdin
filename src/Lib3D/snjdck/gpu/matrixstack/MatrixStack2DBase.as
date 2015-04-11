package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix;

	internal class MatrixStack2DBase
	{
		private var matrixStack:Vector.<Matrix>;
		private var matrixIndex:int;
		
		public function MatrixStack2DBase()
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
		}
		
		public function popMatrix():void
		{
			--matrixIndex;
		}
		
		protected function get currentMatrix():Matrix
		{
			return matrixStack[matrixIndex];
		}
		
		protected function get previousMatrix():Matrix
		{
			if(matrixIndex <= 0){
				return null;
			}
			return matrixStack[matrixIndex-1];
		}
	}
}