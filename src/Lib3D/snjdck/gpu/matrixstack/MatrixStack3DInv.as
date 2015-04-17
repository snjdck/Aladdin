package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix3D;

	public class MatrixStack3DInv extends MatrixStack3DBase
	{
		public function MatrixStack3DInv(){}
		
		override public function pushMatrix(matrix:Matrix3D):void
		{
			super.pushMatrix(matrix);
			currentMatrix.copyFrom(matrix);
			currentMatrix.invert();
			if(previousMatrix != null){
				currentMatrix.prepend(previousMatrix);
			}
		}
		
		public function get worldMatrixInv():Matrix3D
		{
			return currentMatrix;
		}
	}
}