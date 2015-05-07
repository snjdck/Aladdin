package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	
	import matrix44.extractPosition;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.bound.Rect45;

	internal class ViewFrustum extends Rect45
	{
		public function ViewFrustum(){}
		
		public function updateAABB(cameraWorldMatrix:Matrix3D):void
		{
			matrix44.extractPosition(cameraWorldMatrix, center);
			center.z =  center.y - center.x;
			center.w = -center.y - center.x;
		}
		
		public function containsAABB(bound:AABB):Boolean
		{
			return hitTestRect(bound.center, bound.halfSize);
		}
	}
}