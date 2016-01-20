package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;

	internal class SubEntity extends Object3D implements IDrawUnit3D
	{
		internal var subMesh:SubMesh;
		
		public function SubEntity(subMesh:SubMesh)
		{
			this.subMesh = subMesh;
			originalBound = subMesh.geometry.bound;
		}
		
		private function get entity():Entity
		{
			return parent as Entity;
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, parent.worldTransform);
			subMesh.draw(context3d, entity);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(scene.camera.isInSight(parent.worldBound)){
				collector.addDrawUnit(this);
			}
		}
		
		public function get shaderName():String
		{
			return entity.shaderName;
		}
		
		override public function get blendMode():BlendMode
		{
			return parent.blendMode;
		}
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			return bound.hitRay(localRay, mouseLocation);
		}
	}
}