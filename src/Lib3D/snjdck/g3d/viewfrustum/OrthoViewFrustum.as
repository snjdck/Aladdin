package snjdck.g3d.viewfrustum
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.bound.OBB3;

	public class OrthoViewFrustum implements ViewFrustum
	{
		private var zNear:Number;
		private var zFar:Number;
		
		private var halfWidth:Number;
		private var halfHeight:Number;
		
		private const obb:OBB3 = new OBB3();
		
		public function OrthoViewFrustum(width:Number, height:Number, zNear:Number, zFar:Number)
		{
			obb.setCenterAndSize(new Vector3D(0, 0, 0.5 * (zNear+zFar)), new Vector3D(width, height, zFar-zNear));
		}
		
		public function isSphereVisible(pos:Vector3D, radius:Number):Boolean
		{
			if(pos.z + radius <= zNear){
				return false;
			}
			if(pos.z - radius >= zFar){
				return false;
			}
			if(pos.x + radius <= -halfWidth){
				return false;
			}
			if(pos.x - radius >= halfWidth){
				return false;
			}
			if(pos.y + radius <= -halfHeight){
				return false;
			}
			if(pos.y - radius >= halfHeight){
				return false;
			}
			return true;
		}
		
		public function updateAABB(cameraWorldMatrix:Matrix3D):void
		{
			obb.transform(cameraWorldMatrix, tempAABB);
		}
		
		public function containsAABB(bound:AABB):Boolean
		{
			return tempAABB.hitTestAABB(bound);
		}
		
		static private const tempAABB:OBB3 = new OBB3();
	}
}