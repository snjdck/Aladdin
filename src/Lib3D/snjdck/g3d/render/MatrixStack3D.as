package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.gpu.state.StateStack;

	final public class MatrixStack3D
	{
		private const stack:StateStack = new StateStack(Matrix3D);
		
		public function MatrixStack3D(){}
		
		public function pushMatrix(matrix:Matrix3D):void
		{
			stack.push();
			var worldMatrix:Matrix3D = stack.state;
			worldMatrix.copyFrom(matrix);
			if(stack.count > 1){
				worldMatrix.append(stack.prevState);
			}
		}
		
		public function popMatrix():void
		{
			stack.pop();
		}
		
		public function get worldMatrix():Matrix3D
		{
			return stack.state;
		}
	}
}