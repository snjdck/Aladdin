package snjdck.g3d.mesh
{
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.IGpuTexture;

	public class SubMesh
	{
		public var mesh:Mesh;
		public var materialName:String;
		public var geometry:Geometry;
		
		public function SubMesh(mesh:Mesh)
		{
			this.mesh = mesh;
		}
		
		public function draw(context3d:GpuContext, boneStateGroup:BoneStateGroup):void
		{
			if(context3d.isFsSlotInUse(0)){
				var texture:IGpuTexture = AssetMgr.Instance.getTexture(materialName);
				context3d.texture = texture;
				context3d.markRecoverableGpuAsset(texture);
			}
			geometry.draw(context3d, boneStateGroup);
		}
		
		public function mergeSubMeshBound(result:AABB):void
		{
			result.merge(geometry.bound);
		}
	}
}