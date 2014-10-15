package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Bound;
	
	use namespace ns_g3d;

	/**
	 * plane ax+by+cz+d=0
	 */	
	public class ViewFrustum
	{
		private var aabbPoints:Vector.<Number>;
		
		ns_g3d const left:Vector3D = new Vector3D();
		ns_g3d const right:Vector3D = new Vector3D();
		
		ns_g3d const top:Vector3D = new Vector3D();
		ns_g3d const bottom:Vector3D = new Vector3D();
		
		ns_g3d const near:Vector3D = new Vector3D(0, 0, 1);
		ns_g3d const far:Vector3D = new Vector3D(0, 0, -1);
		
		public function ViewFrustum()
		{
			aabbPoints = new Vector.<Number>(24, true);
		}
		
		public function isBoundVisible(bound:Bound, matrix:Matrix3D):Boolean
		{
			return isSphereVisible(matrix.position, bound.radius) && isBoxVisible(bound, matrix);
		}
		
		private function isSphereVisible(pos:Vector3D, radius:Number):Boolean
		{
			var negRadius:Number = -radius;
			if(distanceToPlane(left, pos) <= negRadius)	return false;
			if(distanceToPlane(right, pos) <= negRadius)	return false;
			if(distanceToPlane(top, pos) <= negRadius)	return false;
			if(distanceToPlane(bottom, pos) <= negRadius)	return false;
			if(distanceToPlane(near, pos) <= negRadius)	return false;
			if(distanceToPlane(far, pos) <= negRadius)	return false;
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
		
		static private const tempRawData:Vector.<Number> = new Vector.<Number>(16, true);
		static private const tempPoint:Vector3D = new Vector3D();
	}
}