package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.render.DrawUnitCollector3D;
	
	use namespace ns_g3d;

	internal class EntityMeshGroup
	{
		private const subEntityList:Vector.<SubEntity> = new Vector.<SubEntity>();
		private var entity:Entity;
		
		public function EntityMeshGroup(entity:Entity)
		{
			this.entity = entity;
		}
		
		public function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.visible){
					collector.addDrawUnit(subEntity);
				}
			}
		}
		
		public function hasMesh(mesh:Mesh):Boolean
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.subMesh.mesh == mesh){
					return true;
				}
			}
			return false;
		}
		
		public function addMesh(mesh:Mesh):void
		{
			if(hasMesh(mesh))
				return;
			for(var i:int=0; i<mesh.subMeshes.length; ++i){
				var subMesh:SubMesh = mesh.subMeshes[i];
				var subEntity:SubEntity = new SubEntity(subMesh);
				entity.addChild(subEntity);
				subEntityList.push(subEntity);
			}
		}
		
		public function removeMesh(child:Mesh):void
		{
			for(var i:int=subEntityList.length-1; i>=0; --i){
				var subEntity:SubEntity = subEntityList[i];
				if(subEntity.subMesh.mesh == child){
					subEntityList.splice(i, 1);
					entity.removeChild(subEntity);
				}
			}
		}
		
		public function calculateBound(result:AABB):void
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.visible){
					subEntity.subMesh.mergeSubMeshBound(result);
				}
			}
		}
		
		public function hideSubMeshAt(index:int):void
		{
			var subEntity:SubEntity = subEntityList[index];
			subEntity.visible = false;
		}
	}
}