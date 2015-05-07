package snjdck.g3d.render
{
	import flash.geom.Matrix3D;

	final public class MatrixStack3D
	{
		private var matrixStack:Vector.<Matrix3D>;
		private var matrixIndex:int;
		
		public function MatrixStack3D()
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
			worldMatrix.copyFrom(matrix);
			if(matrixIndex > 0){
				worldMatrix.append(matrixStack[matrixIndex-1]);
			}
		}
		
		public function popMatrix():void
		{
			--matrixIndex;
		}
		
		public function get worldMatrix():Matrix3D
		{
			return matrixStack[matrixIndex];
		}
	}
}