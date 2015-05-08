package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.render.MatrixStack3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneAttachmentGroup;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;

	public class Entity extends Object3D implements IDrawUnit3D
	{
		public var enableXRay:Boolean;
		
		private var subEntityList:Vector.<SubEntity> = new Vector.<SubEntity>();
		private var hasSkeleton:Boolean;
		private var skeleton:Skeleton;
		
		private var boneStateGroup:BoneStateGroup = new BoneStateGroup();
		private const boneAttachmentGroup:BoneAttachmentGroup = new BoneAttachmentGroup();
		
		public function Entity(mesh:Mesh)
		{
			blendMode = BlendMode.NORMAL;
			
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subEntityList.push(new SubEntity(subMesh));
			}
			
			hasSkeleton = (mesh.skeleton != null);
			
			if(hasSkeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
				boneStateGroup.skeleton = skeleton;
			}
		}
		
		public function isInSight(camera3d:Camera3D):Boolean
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(camera3d.isInSight(subEntity.worldBound)){
					return true;
				}
			}
			return false;
		}
		
		public function draw(context3d:GpuContext, camera3d:Camera3D):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, prevWorldMatrix);
			for each(var subEntity:SubEntity in subEntityList){
				if(camera3d.isInSight(subEntity.worldBound)){
					subEntity.draw(context3d, boneStateGroup);
				}
			}
		}
		
		public function get shaderName():String
		{
			return hasSkeleton ? ShaderName.DYNAMIC_OBJECT : ShaderName.STATIC_OBJECT;
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera3d:Camera3D):void
		{
			if(enableXRay){
				collector.xrayFlag = true;
			}
			
			super.collectDrawUnit(collector, camera3d);
			
			if(hasSkeleton && boneAttachmentGroup.hasAttachments()){
				boneAttachmentGroup.collectDrawUnits(collector, camera3d);
			}
			
			for each(var subEntity:SubEntity in subEntityList){
				subEntity.updateBound(prevWorldMatrix);
			}
			
			if(subEntityList.length > 0 && isInSight(camera3d)){
				collector.addDrawUnit(this);
			}
			if(enableXRay){
				collector.xrayFlag = false;
			}
		}
		
		override protected function onHitTest(localRay:Ray):Boolean
		{
			for each(var subEntity:SubEntity in subEntityList){
				if(subEntity.testRay(localRay, mouseLocation)){
					return true;
				}
			}
			return false;
		}
		
		private function checkBoneName(boneName:String):Bone
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			return bone;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			var boneId:int = checkBoneName(boneName).id;
			boneAttachmentGroup.addAttachment(boneId, entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			checkBoneName(boneName);
			var boneId:int = checkBoneName(boneName).id;
			boneAttachmentGroup.removeAttachment(boneId, entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			checkBoneName(boneName);
			var boneId:int = checkBoneName(boneName).id;
			boneAttachmentGroup.removeAttachmentsOnBone(boneId);
		}
		
		public function shareSkeletonInstanceWith(entity:Entity):void
		{
			skeleton = null;
			boneStateGroup = entity.boneStateGroup;
		}
		
		override public function onUpdate(matrixStack:MatrixStack3D, timeElapsed:int):void
		{
			super.onUpdate(matrixStack, timeElapsed);
			updateBoneState(timeElapsed);
			if(hasSkeleton && boneAttachmentGroup.hasAttachments()){
				matrixStack.pushMatrix(transform);
				boneAttachmentGroup.onUpdate(matrixStack, boneStateGroup, timeElapsed);
				matrixStack.popMatrix();
			}
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.animation = skeleton.getAnimationByName(value);
		}
		
		public function updateBoneState(timeElapsed:int):void
		{
			if(skeleton != null){
				boneStateGroup.advanceTime(timeElapsed * 0.001);
			}
		}
		
		public function calculateBound():void
		{
			prevWorldMatrix.copyFrom(transform);
			for each(var subEntity:SubEntity in subEntityList){
				subEntity.updateBound(prevWorldMatrix);
			}
		}
		
		public function getEntityBound(bound:AABB):void
		{
			if(subEntityList.length < 1){
				return;
			}
			var subEntity:SubEntity = subEntityList[0];
			bound.copyFrom(subEntity.worldBound);
			for(var i:int=subEntityList.length-1; i > 0; --i){
				subEntity = subEntityList[i];
				bound.merge(subEntity.worldBound);
			}
		}
	}
}