package snjdck.g3d.entities
{
	import flash.geom.Matrix3D;
	
	import array.del;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;
	
	public class SkeletonEntity extends DisplayObjectContainer3D implements IDrawUnit3D, IEntity
	{
		private const meshList:Array = [];
		private var skeleton:Skeleton;
		
		private var boneStateGroup:BoneStateGroup;
		private var bound:EntityBound;
		
		public function SkeletonEntity(mesh:Mesh)
		{
			bound = new EntityBound(this);
			skeleton = mesh.skeleton;
			boneStateGroup = new BoneStateGroup(skeleton);
			aniName = skeleton.getAnimationNames()[0];
			addMesh(mesh);
		}
		
		public function get worldBound():AABB
		{
			return bound.worldBound;
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			bound.markWorldBoundDirty();
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			boneStateGroup.stepAnimation(timeElapsed * 0.001);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(collector.isInSight(worldBound)){
				if(boneStateGroup.isDirty){
					skeleton.updateBoneState(boneStateGroup);
					boneStateGroup.isDirty = false;
					for(var i:int=0, n:int=numChildren; i<n; ++i){
						updateBoneAttachments(getChildAt(i));
					}
				}
				collector.addItem(this, RenderPriority.SKELETON_OBJECT);
				super.collectDrawUnit(collector);
			}
		}
		
		private function updateBoneAttachments(attachments:Object3D):void
		{
			var boneState:Matrix4x4 = boneStateGroup.getBoneStateLocal(attachments.id);
			boneState.toMatrix(boneMatrix);
			attachments.transform = boneMatrix;
		}
		
		static private const boneMatrix:Matrix3D = new Matrix3D();
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldTransform);
			for each(var mesh:Mesh in meshList){
				for each(var subMesh:SubMesh in mesh.subMeshes){
					subMesh.draw(context3d, boneStateGroup);
				}
			}
		}
		
		public function getBoneAttachments(boneName:String):DisplayObjectContainer3D
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			var attachments:Object3D = getChildById(bone.id);
			if(null == attachments){
				attachments = new DisplayObjectContainer3D();
				attachments.id = bone.id;
				addChild(attachments);
				if(!boneStateGroup.isDirty){
					updateBoneAttachments(attachments);
				}
			}
			return attachments as DisplayObjectContainer3D;
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.changeAnimation(value);
		}
		
		public function addMesh(mesh:Mesh):void
		{
			meshList.push(mesh);
			mesh.mergeBound(bound.localBound);
			bound.markWorldBoundDirty();
		}
		
		public function removeMesh(mesh:Mesh):void
		{
			array.del(meshList, mesh);
			bound.localBound.clear();
			for each(var otherMesh:Mesh in meshList){
				otherMesh.mergeBound(bound.localBound);
			}
			bound.markWorldBoundDirty();
		}
		
		public function hideSubMeshAt(index:int):void
		{
		}
	}
}