package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import matrix33.concat;
	import matrix33.transformCoords;

	public class MatrixStack2DInv extends MatrixStack2DBase
	{
		public function MatrixStack2DInv(){}
		
		override public function pushMatrix(matrix:Matrix):void
		{
			super.pushMatrix(matrix);
			currentMatrix.copyFrom(matrix);
			currentMatrix.invert();
			if(previousMatrix != null){
				matrix33.concat(previousMatrix, currentMatrix, currentMatrix);
			}
		}
		/*
		public function get worldMatrixInv():Matrix
		{
			return currentMatrix;
		}
		*/
		public function transformCoords(x:Number, y:Number, output:Point):void
		{
			matrix33.transformCoords(currentMatrix, x, y, output);
		}
	}
}