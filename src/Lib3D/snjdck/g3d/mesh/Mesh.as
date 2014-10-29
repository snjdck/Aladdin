package snjdck.g3d.mesh
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.skeleton.Skeleton;
	
	use namespace ns_g3d;
	
	public class Mesh
	{
		ns_g3d var subMeshes:Array;
		ns_g3d var skeleton:Skeleton;
		public const bound:AABB = new AABB();
		
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
			var entity:Entity = new entityCls(this);
			entity.name = name;
			return entity;
		}
	}
}