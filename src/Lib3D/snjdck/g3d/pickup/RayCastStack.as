package snjdck.g3d.pickup
{
	import flash.geom.Matrix3D;
	
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;

	public class RayCastStack
	{
		private var rayStack:Vector.<Ray>;
		private var rayIndex:int;
		
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
			
			ray.worldMatrix.copyFrom(matrix);
			ray.worldMatrix.append(prevRay.worldMatrix);
			
			transform.copyFrom(matrix);
			transform.invert();
			
			matrix44.transformVector(transform, prevRay.pos, ray.pos);
			matrix44.transformVectorDelta(transform, prevRay.dir, ray.dir);
		}
		
		public function popRay():void
		{
			--rayIndex;
		}
		
		public function get ray():Ray
		{
			return rayStack[rayIndex];
		}
		
		static private const transform:Matrix3D = new Matrix3D();
	}
}