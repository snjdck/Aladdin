package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix;

	public class MatrixStack2D extends MatrixStack2DBase
	{
		public function MatrixStack2D(){}
		
		override public function pushMatrix(matrix:Matrix):void
		{
			super.pushMatrix(matrix);
			currentMatrix.copyFrom(matrix);
			if(previousMatrix != null){
				currentMatrix.concat(previousMatrix);
			}
		}
		
		public function get worldMatrix():Matrix
		{
			return currentMatrix;
		}
	}
}