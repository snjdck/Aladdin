package snjdck.g3d.viewfrustum
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;

	public interface ViewFrustum
	{
		function isSphereVisible(pos:Vector3D, radius:Number):Boolean;
		function updateAABB(cameraWorldMatrix:Matrix3D):void;
		function containsAABB(bound:AABB):Boolean;
	}
}