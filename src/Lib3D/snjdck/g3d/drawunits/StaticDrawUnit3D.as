package snjdck.g3d.drawunits
{
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.entities.SubEntity;
	import snjdck.g3d.parser.Geometry;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.g3d.renderer.DrawUnit3D;

	public class StaticDrawUnit3D extends DrawUnit3D
	{
		private var subEntities:Array;
		
		public function StaticDrawUnit3D(target:Object3D, subEntities:Array)
		{
			super(target);
			this.subEntities = subEntities;
		}
		
		override public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, target.worldTransform);
			for each(var subEntity:SubEntity in subEntities){
				if(subEntity.visible){
					subEntity.subMesh.draw(context3d, null);
				}
			}
		}
	}
}