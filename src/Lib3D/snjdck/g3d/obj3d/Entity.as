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
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneAttachmentGroup;
	import snjdck.g3d.skeleton.BoneObject3D;
	import snjdck.g3d.skeleton.IBoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.BlendMode;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class Entity extends DisplayObjectContainer3D implements IBoneStateGroup
	{
		private var hasSkeleton:Boolean;
		private var skeleton:Skeleton;
		
		public var animation:Animation;
		public var animationTime:Number = 0;
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
			bound.transform(worldTransform, worldBound);
		}
		
		override protected function onWorldMatrixDirty():void
		{
			super.onWorldMatrixDirty();
			bound.transform(worldTransform, worldBound);
		}
		
		public function getBoneState(boneId:int):Matrix4x4
		{
			var boneObject:BoneObject3D = boneStateGroup[boneId];
			return boneObject.getBoneStateGlobal();
		}
		
		public function regBone(boneObject:BoneObject3D):void
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
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			var boneObject:BoneObject3D = boneStateGroup[bone.id];
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
		/*
		public function shareSkeletonInstanceWith(entity:Entity):void
		{
			skeleton = null;
			boneStateGroup = entity.boneStateGroup;
		}
		*/
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(scene.camera.isInSight(worldBound)){
				collector.addUpdateable(this);
				meshGroup.collectDrawUnit(collector);
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
			animation = skeleton.getAnimationByName(value);
		}
		
		public function updateBoneState(timeElapsed:int):void
		{
			if(skeleton != null && animation.length > 0){
				animationTime += timeElapsed * 0.001;
				if(animationTime > animation.length){
					animationTime -= animation.length;
				}
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
		/*
		public function bindBoneStateGroup(value:Array):void
		{
			skeleton = null;
			boneStateGroup = value;
		}
		*/
		public function clearSkeleton():void
		{
			hasSkeleton = false;
			skeleton = null;
		}
		
		public function hideSubMeshAt(index:int):void
		{
			meshGroup.hideSubMeshAt(index);
		}
		
		internal function handleSubEntity(subMesh:SubMesh):void
		{
			for each(var boneObject:BoneObject3D in boneStateGroup){
				if(null == boneObject){
					continue;
				}
				boneObject.addVertex(subMesh.geometry);
			}
		}
	}
}