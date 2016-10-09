package snjdck.g3d.entities
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class StaticEntity extends Object3D implements IDrawUnit3D, IEntity
	{
		private var subEntities:Array = [];
		
		private const _worldBound:AABB = new AABB();
		private const localBound:AABB = new AABB();
		private var isWorldBoundDirty:Boolean = true;
		
		public function StaticEntity(mesh:Mesh)
		{
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subMesh.mergeBound(localBound);
				subEntities.push(new SubEntity(subMesh));
			}
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			isWorldBoundDirty = true;
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(collector.isInSight(worldBound)){
				collector.addItem(this, RenderPriority.STATIC_OBJECT);
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
		
		public function get shaderName():String
		{
			return ShaderName.STATIC_OBJECT;
		}

		public function get worldBound():AABB
		{
			if(isWorldBoundDirty){
				localBound.transform(worldTransform, _worldBound);
				isWorldBoundDirty = false;
			}
			return _worldBound;
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