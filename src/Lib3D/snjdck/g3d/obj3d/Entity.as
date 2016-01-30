package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.AnimationInstance;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneAttachmentGroup;
	import snjdck.g3d.skeleton.BoneInstance;
	import snjdck.g3d.skeleton.IBoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.BlendMode;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class Entity extends DisplayObjectContainer3D implements IBoneStateGroup
	{
		private var hasSkeleton:Boolean;
		private var skeleton:Skeleton;
		
		ns_g3d var animationInstance:AnimationInstance;
		private const boneStateGroup:Array = [];
		public var isBoneDirty:Boolean = true;
		
		public const worldBound:AABB = new AABB();
		public const bound:AABB = new AABB();
		private const meshGroup:EntityMeshGroup = new EntityMeshGroup(this);
		
		public function Entity(mesh:Mesh)
		{
			blendMode = BlendMode.NORMAL;
			hasSkeleton = (mesh.skeleton != null);
			
			if(hasSkeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
				skeleton.createObject3D(this);
			}
			
			addMesh(mesh);
			meshGroup.calculateBound(bound);
		}
		/*
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			bound.transform(worldTransform, worldBound);
		}
		*/
		public function getBoneState(boneId:int):Matrix4x4
		{
			var boneObject:BoneInstance = boneStateGroup[boneId];
			return boneObject.getBoneStateGlobal();
		}
		
		public function regBone(boneObject:BoneInstance):void
		{
			boneStateGroup[boneObject.id] = boneObject;
		}
		
		public function get shaderName():String
		{
			return hasSkeleton ? ShaderName.DYNAMIC_OBJECT : ShaderName.STATIC_OBJECT;
		}
		
		private function getBoneAttachmentGroup(boneName:String):BoneAttachmentGroup
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone)
				throw new Error("boneName '" + boneName + "' not exist!");
			var boneObject:BoneInstance = boneStateGroup[bone.id];
			return boneObject.attachmentGroup;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			getBoneAttachmentGroup(boneName).addAttachment(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			getBoneAttachmentGroup(boneName).removeAttachment(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			getBoneAttachmentGroup(boneName).removeAllAttachments();
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			bound.transform(worldTransform, worldBound);
			if(scene.camera.isInSight(worldBound)){
				collector.addUpdateable(this);
				meshGroup.collectDrawUnit(collector);
				super.collectDrawUnit(collector);
			}
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			updateBoneState(timeElapsed);
			super.onUpdate(timeElapsed);
			if(hasSkeleton && isBoneDirty){
//				markOriginalBoundDirty();
				for(var i:int=numChildren-1; i>=0; --i){
					var boneObject:Object3D = getChildAt(i);
					boneObject.markWorldMatrixDirty();
				}
			}
			isBoneDirty = false;
		}
		
		public function set aniName(value:String):void
		{
			var animation:Animation = skeleton.getAnimationByName(value);
			if(animation != null){
				animationInstance = new AnimationInstance(animation);
			}
		}
		
		public function updateBoneState(timeElapsed:int):void
		{
			if(skeleton != null && animationInstance.hasAnimation()){
				animationInstance.update(timeElapsed);
				isBoneDirty = true;
			}
		}
		
		public function addMesh(mesh:Mesh):void
		{
			meshGroup.addMesh(mesh);
		}
		
		public function removeMesh(mesh:Mesh):void
		{
			meshGroup.removeMesh(mesh);
		}
		
		public function hideSubMeshAt(index:int):void
		{
			meshGroup.hideSubMeshAt(index);
		}
		
		internal function handleSubEntity(subMesh:SubMesh):void
		{
			for each(var boneObject:BoneInstance in boneStateGroup){
				if(null == boneObject)
					continue;
				boneObject.addVertex(subMesh.geometry);
			}
		}
	}
}