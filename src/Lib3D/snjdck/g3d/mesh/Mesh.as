package snjdck.g3d.mesh
{
	import array.pushIfNotHas;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.obj3d.Entity;
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
		
		public function createSubMesh():SubMesh
		{
			var subMesh:SubMesh = new SubMesh();
			subMeshes.push(subMesh);
			return subMesh;
		}
		
		public function createEntity(name:String=null):Entity
		{
			var entity:Entity = new Entity(this);
			entity.name = name;
			return entity;
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