package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix3D;
	
	internal class MatrixStack3DBase
	{
		private var matrixStack:Vector.<Matrix3D>;
		private var matrixIndex:int;
		
		public function MatrixStack3DBase()
		{
			matrixStack = new Vector.<Matrix3D>();
			matrixIndex = -1;
		}
		
		public function pushMatrix(matrix:Matrix3D):void
		{
			++matrixIndex;
			if(matrixStack.length <= matrixIndex){
				matrixStack.push(new Matrix3D());
			}
		}
		
		public function popMatrix():void
		{
			--matrixIndex;
		}
		
		protected function get currentMatrix():Matrix3D
		{
			return matrixStack[matrixIndex];
		}
		
		protected function get previousMatrix():Matrix3D
		{
			if(matrixIndex <= 0){
				return null;
			}
			return matrixStack[matrixIndex-1];
		}
	}
}