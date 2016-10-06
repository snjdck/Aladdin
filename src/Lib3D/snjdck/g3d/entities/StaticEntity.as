package snjdck.g3d.entities
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class StaticEntity extends Object3D implements IDrawUnit3D
	{
		private var mesh:Mesh;
		private var subEntities:Array = [];
		
		public function StaticEntity(mesh:Mesh)
		{
			this.mesh = mesh;
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subEntities.push(new SubEntity(subMesh));
			}
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.addDrawUnit(this);
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
		
	}
}