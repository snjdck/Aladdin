package snjdck.g3d.obj3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;

	internal class SubEntity
	{
		private var subMesh:SubMesh;
		public const worldBound:AABB = new AABB();
		
		public function SubEntity(subMesh:SubMesh)
		{
			this.subMesh = subMesh;
		}
		
		public function updateBound(worldMatrix:Matrix3D):void
		{
			subMesh.geometry.bound.transform(worldMatrix, worldBound);
		}
		
		public function draw(context3d:GpuContext, boneStateGroup:BoneStateGroup):void
		{
			if(context3d.isFsSlotInUse(0)){
				context3d.texture = AssetMgr.Instance.getTexture(subMesh.materialName);
			}
			subMesh.geometry.draw(context3d, boneStateGroup);
		}
		
		public function testRay(ray:Ray, mouseLocation:Vector3D):Boolean
		{
			return true;
		}
	}
}