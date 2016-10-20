package snjdck.g3d.entities
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.renderer.IDrawUnitCollector3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.renderer.IDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class StaticEntity extends Object3D implements IDrawUnit3D, IEntity
	{
		private const subEntities:Array = [];
		private var bound:EntityBound;
		
		public function StaticEntity(mesh:Mesh)
		{
			bound = new EntityBound(this);
			mesh.mergeBound(bound.localBound);
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subEntities.push(new SubEntity(subMesh));
			}
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			bound.markWorldBoundDirty();
		}
		
		override ns_g3d function collectDrawUnit(collector:IDrawUnitCollector3D):void
		{
			if(collector.isInSight(worldBound)){
				collector.addDrawUnit(this, RenderPriority.STATIC_OBJECT);
			}
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldTransform);
			for each(var subEntity:SubEntity in subEntities){
				if(subEntity.visible){
					subEntity.subMesh.draw(context3d, null);
				}
			}
		}

		public function get worldBound():IBound
		{
			return bound.worldBound;
		}
		
		public function setSubMeshVisible(index:int, value:Boolean):void
		{
			var subEntity:SubEntity = subEntities[index];
			subEntity.visible = value;
		}
		
		public function hideSubMeshAt(index:int):void
		{
			setSubMeshVisible(index, false);
		}
	}
}