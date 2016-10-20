package snjdck.g3d.drawunits
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.renderer.DrawUnit3D;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;
	
	public class SkeletonDrawUnit3D extends DrawUnit3D
	{
		private var meshList:Array;
		private var boneStateGroup:BoneStateGroup;
		
		public function SkeletonDrawUnit3D(target:Object3D, meshList:Array, boneStateGroup:BoneStateGroup)
		{
			super(target);
			this.meshList = meshList;
			this.boneStateGroup = boneStateGroup;
		}
		
		override public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, target.worldTransform);
			for each(var mesh:Mesh in meshList){
				for each(var subMesh:SubMesh in mesh.subMeshes){
					subMesh.draw(context3d, boneStateGroup);
				}
			}
		}
	}
}