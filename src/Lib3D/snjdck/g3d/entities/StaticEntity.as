package snjdck.g3d.entities
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.renderer.IDrawUnit3D;
	import snjdck.g3d.renderer.IDrawUnitCollector3D;
	import snjdck.g3d.drawunits.StaticDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	
	use namespace ns_g3d;

	public class StaticEntity extends Object3D implements IEntity
	{
		private const subEntities:Array = [];
		private var bound:EntityBound;
		private var drawUnit:IDrawUnit3D;
		
		public function StaticEntity(mesh:Mesh)
		{
			bound = new EntityBound(this);
			mesh.mergeBound(bound.localBound);
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subEntities.push(new SubEntity(subMesh));
			}
			drawUnit = new StaticDrawUnit3D(this, subEntities);
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			bound.markWorldBoundDirty();
		}
		
		override ns_g3d function collectDrawUnit(collector:IDrawUnitCollector3D):void
		{
			if(collector.isInSight(worldBound)){
				collector.addDrawUnit(drawUnit, RenderPriority.STATIC_OBJECT);
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