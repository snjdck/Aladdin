package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.extractPosition;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.bound.OBB3;
	import snjdck.g3d.bound.Sphere;
	import snjdck.gpu.geom.OBB2;
	
	import stdlib.constant.Unit;

	internal class ViewFrustum
	{
		private var zNear:Number;
		private var zFar:Number;
		
		private var halfWidth:Number;
		private var halfHeight:Number;
		
		private const obb3:OBB3 = new OBB3();
		private const obb2:OBB2 = new OBB2();
		public const sphere:Sphere = new Sphere();
		
		public function ViewFrustum()
		{
		}
		
		public function update(width:Number, height:Number):void
		{
			zNear = Projection3D.zNear;
			zFar = Projection3D.zFar;
			
			obb3.setCenterAndSize(new Vector3D(0, 0, 0.5 * (zFar + zNear)), new Vector3D(width, height, zFar - zNear));
			obb2.center = new Vector3D();
			obb2.rotation = 45 * Unit.RADIAN;
			obb2.halfWidth = width * 0.5;
			obb2.halfHeight = 0.25 * ((zFar - zNear) * Math.sqrt(3) + height);
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
			obb3.transform(cameraWorldMatrix, tempAABB);
			matrix44.extractPosition(cameraWorldMatrix, obb2.center);
		}
		
		public function containsAABB(bound:AABB):Boolean
		{
			return tempAABB.hitTestAABB(bound);
		}
		
		private const tempAABB:OBB3 = new OBB3();
	}
}