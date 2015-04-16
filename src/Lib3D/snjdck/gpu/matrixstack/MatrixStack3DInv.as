package snjdck.gpu.matrixstack
{
	import flash.geom.Matrix3D;
	
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.pickup.Ray;

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
		
		public function transformRay(input:Ray, output:Ray):void
		{
			matrix44.transformVector(currentMatrix, input.pos, output.pos);
			matrix44.transformVectorDelta(currentMatrix, input.dir, output.dir);
		}
	}
}