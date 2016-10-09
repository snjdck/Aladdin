package snjdck.g3d.mesh
{
	import array.pushIfNotHas;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.entities.IEntity;
	import snjdck.g3d.entities.SkeletonEntity;
	import snjdck.g3d.entities.StaticEntity;
	import snjdck.g3d.skeleton.Skeleton;
	
	use namespace ns_g3d;
	
	public class Mesh
	{
		ns_g3d const subMeshes:Array = [];
		ns_g3d var skeleton:Skeleton;
		
		public function Mesh(){}
		
		public function get subMeshCount():uint
		{
			return subMeshes.length;
		}
		
		public function mergeBound(result:AABB):void
		{
			for each(var subMesh:SubMesh in subMeshes){
				subMesh.mergeBound(result);
			}
		}
		
		public function createSubMesh():SubMesh
		{
			var subMesh:SubMesh = new SubMesh(this);
			subMeshes.push(subMesh);
			return subMesh;
		}
		
		public function createEntity(name:String=null):IEntity
		{
			var entity:Object3D;
			if(skeleton != null){
				entity = new SkeletonEntity(this);
			}else{
				entity = new StaticEntity(this);
			}
			entity.name = name;
			return entity as IEntity;
		}
		
		public function getTextureNames():Array
		{
			var result:Array = [];
			for each(var subMesh:SubMesh in subMeshes){
				array.pushIfNotHas(result, subMesh.materialName);
			}
			return result;
		}
	}
}