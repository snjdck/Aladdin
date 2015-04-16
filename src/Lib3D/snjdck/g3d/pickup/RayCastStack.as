package snjdck.g3d.pickup
{
	import flash.geom.Matrix3D;
	
	import snjdck.gpu.matrixstack.MatrixStack3DInv;

	public class RayCastStack
	{
		private var rayStack:Vector.<Ray>;
		private var rayIndex:int;
		private var matrixStack:MatrixStack3DInv = new MatrixStack3DInv();
		
		public function RayCastStack()
		{
			rayStack = new <Ray>[new Ray()];
			rayIndex = 0;
		}
		
		public function pushRay(matrix:Matrix3D):void
		{
			const prevRay:Ray = ray;
			
			++rayIndex;
			if(rayStack.length <= rayIndex){
				rayStack.push(new Ray());
			}
			
			matrixStack.pushMatrix(matrix);
			matrixStack.transformRay(prevRay, ray);
		}
		
		public function popRay():void
		{
			--rayIndex;
			matrixStack.popMatrix();
		}
		
		public function get ray():Ray
		{
			return rayStack[rayIndex];
		}
	}
}