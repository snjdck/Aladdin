package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.render.DrawUnit3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneAttachmentGroup;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.BlendMode;
	
	use namespace ns_g3d;

	public class Entity extends Object3D
	{
		ns_g3d var mesh:Mesh;
		ns_g3d var skeleton:Skeleton;
		
		public var aniName:String;
		private var aniTime:int;
		public var timeScale:Number = 1;
		
		private var boneStateGroup:BoneStateGroup = new BoneStateGroup();
		private const boneAttachmentGroup:BoneAttachmentGroup = new BoneAttachmentGroup();
		
		public function Entity(mesh:Mesh)
		{
			this.mesh = mesh;
			blendMode = BlendMode.NORMAL;
			
			if(mesh.skeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
			}
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			super.collectDrawUnit(collector);
//			skeleton.onUpdate(aniName, aniTime * 0.001, boneStateGroup);
			boneAttachmentGroup.collectDrawUnits(collector, boneStateGroup);
			
			if(mesh.subMeshes.length <= 0){
				return;
			}
			/*
			if(skeleton){
				boneStateGroup.prependBoneTransform(skeleton);
			}
			*/
//			super.collectDrawUnit(collector);
			/*
			if(!camera.viewFrustum.isBoundVisible(mesh.bound, worldMatrix)){
				++collector.numCulledEntities;
				collector.numCulledDrawUnits += mesh.subMeshes.length;
				return;
			}
			*/
			collector.pushMatrix(transform);
			for each(var subMesh:SubMesh in mesh.subMeshes)
			{
				var drawUnit:DrawUnit3D = collector.getFreeDrawUnit();
				drawUnit.blendMode = blendMode;
				drawUnit.worldMatrix = collector.worldMatrix;
				subMesh.getDrawUnit(drawUnit, boneStateGroup);
				collector.addDrawUnit(drawUnit);
			}
			collector.popMatrix();
		}
		//*
		override protected function hitTestImpl(localRay:Ray, result:Vector.<RayTestInfo>):void
		{
//			var ray:Ray = getLocalRay(globalRay);
//			var ray:Ray = globalRay.transformToLocal(worldMatrix);
			
			var rayTestInfo:RayTestInfo = new RayTestInfo();
			rayTestInfo.target = this;
			
			for each(var subMesh:SubMesh in mesh.subMeshes){
				if(subMesh.testRay(localRay, boneStateGroup, rayTestInfo)){
					result.push(rayTestInfo);
					return;
				}
			}
		}
		//*/
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
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			boneAttachmentGroup.onUpdate(timeElapsed);
			if(null == skeleton){
				return;
			}
			
			const len:int = skeleton.getAnimationLength(aniName) * 1000;
			aniTime += timeElapsed * timeScale;
			if(aniTime > len){
				aniTime -= len;
			}
			skeleton.onUpdate(aniName, aniTime * 0.001, boneStateGroup);
		}
	}
}