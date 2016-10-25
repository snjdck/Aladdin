package snjdck.g3d.mesh
{
	import array.pushIfNotHas;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
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
		
		private const animationBoundDict:Object = {};
		
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
		
		public function getAnimationBound(skeleton:Skeleton, animationName:String):AABB
		{
			var subMesh:SubMesh;
			if(subMeshCount == 1){
				subMesh = subMeshes[0];
				return subMesh.getAnimationBound(skeleton, animationName);
			}
			var bound:AABB = animationBoundDict[animationName];
			if(null == bound){
				bound = new AABB();
				animationBoundDict[animationName] = bound;
				for each(subMesh in subMeshes){
					bound.merge(subMesh.getAnimationBound(skeleton, animationName));
				}
			}
			return bound;
		}
	}
}