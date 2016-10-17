package snjdck.gpu.support
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.gpu.CubeSide;

	public class CubeRotationMatrix
	{
		private const matrixList:Vector.<Matrix3D> = new Vector.<Matrix3D>(6, true);
		
		public function CubeRotationMatrix()
		{
			var matrix:Matrix3D = new Matrix3D();
			matrixList[CubeSide.POSITIVE_Z] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(-90, Vector3D.Y_AXIS);
			matrixList[CubeSide.POSITIVE_X] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(90, Vector3D.Y_AXIS);
			matrixList[CubeSide.NEGATIVE_X] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(90, Vector3D.X_AXIS);
			matrixList[CubeSide.POSITIVE_Y] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(-90, Vector3D.X_AXIS);
			matrixList[CubeSide.NEGATIVE_Y] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(180, Vector3D.Y_AXIS);
			matrixList[CubeSide.NEGATIVE_Z] = matrix;
		}
		
		public function getMatrixAt(index:int):Matrix3D
		{
			return matrixList[index];
		}
	}
}