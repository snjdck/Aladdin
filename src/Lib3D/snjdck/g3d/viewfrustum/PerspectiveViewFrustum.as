package snjdck.g3d.viewfrustum
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.bound.Sphere;
	
	import stdlib.constant.Unit;

	/**
	 * plane ax+by+cz+d=0
	 */
	public class PerspectiveViewFrustum implements ViewFrustum
	{
		private var aabbPoints:Vector.<Number>;
		
		private var zNear:Number;
		private var zFar:Number;
		
		private const left:Vector3D = new Vector3D();
		private const right:Vector3D = new Vector3D();
		
		private const top:Vector3D = new Vector3D();
		private const bottom:Vector3D = new Vector3D();
		
		public const sphere:Sphere = new Sphere();
		
		public function PerspectiveViewFrustum(fieldOfViewY:Number, aspectRatio:Number, zNear:Number, zFar:Number)
		{
			aabbPoints = new Vector.<Number>(24, true);
			
			var tan:Number = Math.tan(0.5 * fieldOfViewY * Unit.RADIAN);
			var factor:Number = tan * tan * (1 + aspectRatio * aspectRatio);
			
			var offset:Number = 0.5 * Math.max(0, (zFar - zNear) - (zFar + zNear) * factor);
			sphere.center.z = zFar - offset;
			sphere.radius = Math.sqrt(offset * offset + zFar * zFar * factor);
		}
		/*
		public function isBoundVisible(bound:Bound, matrix:Matrix3D):Boolean
		{
			return isSphereVisible(matrix.position, bound.radius) && isBoxVisible(bound, matrix);
		}
		*/
		public function isSphereVisible(pos:Vector3D, radius:Number):Boolean
		{
			if(pos.z + radius <= zNear){
				return false;
			}
			if(pos.z - radius >= zFar){
				return false;
			}
			var negRadius:Number = -radius;
			if(distanceToPlane(left, pos) <= negRadius)	return false;
			if(distanceToPlane(right, pos) <= negRadius)	return false;
			if(distanceToPlane(top, pos) <= negRadius)	return false;
			if(distanceToPlane(bottom, pos) <= negRadius)	return false;
			return true;
		}
		
		private function distanceToPlane(plane:Vector3D, pos:Vector3D):Number
		{
			return (plane.x * pos.x) + (plane.y * pos.y) + (plane.z * pos.z) + plane.w;
		}
		
		private function isPointVisible(pt:Vector3D):Boolean
		{
			return isSphereVisible(pt, 0);
		}
		/*
		private function isBoxVisible(bound:Bound, matrix:Matrix3D):Boolean
		{
			bound.transform(matrix, aabbPoints);
			
			for(var i:int=0; i<aabbPoints.length; i+=3){
				tempPoint.setTo(aabbPoints[i], aabbPoints[i+1], aabbPoints[i+2]);
				if(isPointVisible(tempPoint)){
					return true;
				}
			}
			
			return false;
		}
		*/
		static private const tempRawData:Vector.<Number> = new Vector.<Number>(16, true);
		static private const tempPoint:Vector3D = new Vector3D();
		
		public function updateAABB(cameraWorldMatrix:Matrix3D):void
		{
		}
		
		public function containsAABB(bound:AABB):Boolean
		{
			return false;
		}
		
	}
}