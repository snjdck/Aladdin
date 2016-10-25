package snjdck.g3d.entities
{
	import flash.geom.Matrix3D;
	
	import array.del;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.drawunits.SkeletonDrawUnit3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.renderer.IDrawUnit3D;
	import snjdck.g3d.renderer.IDrawUnitCollector3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	
	use namespace ns_g3d;
	
	public class SkeletonEntity extends DisplayObjectContainer3D implements IEntity
	{
		private const meshList:Array = [];
		private var skeleton:Skeleton;
		
		private var animationName:String;
		private var boneStateGroup:BoneStateGroup;
		private var bound:EntityBound;
		
		private var drawUnit:IDrawUnit3D;
		
		public function SkeletonEntity(mesh:Mesh)
		{
			bound = new EntityBound(this);
			skeleton = mesh.skeleton;
			boneStateGroup = new BoneStateGroup(skeleton);
			aniName = skeleton.getAnimationNames()[0];
			addMesh(mesh);
			drawUnit = new SkeletonDrawUnit3D(this, meshList, boneStateGroup);
		}
		
		public function get worldBound():IBound
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
		
		override ns_g3d function collectDrawUnit(collector:IDrawUnitCollector3D):void
		{
			if(collector.isInSight(worldBound)){
				if(boneStateGroup.isDirty){
					skeleton.updateBoneState(boneStateGroup);
					boneStateGroup.isDirty = false;
					for(var i:int=0, n:int=numChildren; i<n; ++i){
						updateBoneAttachments(getChildAt(i));
					}
				}
				collector.addDrawUnit(drawUnit, RenderPriority.SKELETON_OBJECT);
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
			animationName = value;
		}
		
		public function addMesh(mesh:Mesh):void
		{
			meshList.push(mesh);
			bound.localBound.merge(mesh.getAnimationBound(skeleton, animationName));
			mesh.mergeBound(bound.localBound);
			bound.markWorldBoundDirty();
		}
		
		public function removeMesh(mesh:Mesh):void
		{
			array.del(meshList, mesh);
			bound.localBound.clear();
			for each(var otherMesh:Mesh in meshList){
				bound.localBound.merge(otherMesh.getAnimationBound(skeleton, animationName));
				otherMesh.mergeBound(bound.localBound);
			}
			bound.markWorldBoundDirty();
		}
		
		public function hideSubMeshAt(index:int):void
		{
		}
	}
}