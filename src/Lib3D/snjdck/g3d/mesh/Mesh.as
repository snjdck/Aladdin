package snjdck.g3d.mesh
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Bound;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.asset.helper.AssetMgr;
	
	use namespace ns_g3d;
	
	public class Mesh
	{
		ns_g3d var subMeshes:Array;
		public const bound:Bound = new Bound();
		
		ns_g3d var skeletonLink:String;
		ns_g3d var skeleton:Skeleton;
		
		public function Mesh()
		{
			subMeshes = [];
		}
		
		final public function createSubMesh():SubMesh
		{
			var subMesh:SubMesh = new SubMesh();
			subMeshes.push(subMesh);
			return subMesh;
		}
		
		public function createEntity(name:String=null):Entity
		{
			return createEntityImp(name, Entity);
		}
		
		protected function createEntityImp(name:String, entityCls:Class):Entity
		{
			if(skeletonLink || skeleton){
				if(null == skeleton){
					skeleton = AssetMgr.Instance.getSkeleton(skeletonLink);
				}
			}
			
			var entity:Entity = new entityCls(this);
			entity.name = name;
			return entity;
		}
	}
}