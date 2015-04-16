package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix3D;

	public class MatrixStack3D extends MatrixStack3DBase
	{
		public function MatrixStack3D(){}
		
		override public function pushMatrix(matrix:Matrix3D):void
		{
			super.pushMatrix(matrix);
			currentMatrix.copyFrom(matrix);
			if(previousMatrix != null){
				worldMatrix.append(previousMatrix);
			}
		}
		
		public function get worldMatrix():Matrix3D
		{
			return currentMatrix;
		}
	}
}