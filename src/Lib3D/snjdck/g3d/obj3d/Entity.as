package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
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
		
		private var boneStateGroup:BoneStateGroup = new BoneStateGroup();
		private const boneAttachmentGroup:BoneAttachmentGroup = new BoneAttachmentGroup();
		
		public function Entity(mesh:Mesh)
		{
			this.mesh = mesh;
			blendMode = BlendMode.NORMAL;
			
			if(mesh.skeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
				boneStateGroup.skeleton = skeleton;
			}
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			super.collectDrawUnit(collector);
			
			collector.pushMatrix(transform);
			prevWorldMatrix.copyFrom(collector.worldMatrix);
			boneAttachmentGroup.collectDrawUnits(collector, boneStateGroup);
			for each(var subMesh:SubMesh in mesh.subMeshes)
			{
				var drawUnit:DrawUnit3D = subMesh.drawUnit;
				drawUnit.blendMode = blendMode;
				drawUnit.worldMatrix.copyFrom(collector.worldMatrix);
				
				drawUnit.aabb.bind(subMesh.geometry.bound, drawUnit.worldMatrix);
				
				drawUnit.textureName = subMesh.materialName;
				drawUnit.geometry = subMesh.geometry;
				drawUnit.shaderName = subMesh.geometry.shaderName;
				drawUnit.boneStateGroup = boneStateGroup;
				
				collector.addDrawUnit(drawUnit);
			}
			collector.popMatrix();
		}
		
		override protected function hitTestImpl(localRay:Ray, result:Vector.<RayTestInfo>):void
		{
			var rayTestInfo:RayTestInfo = new RayTestInfo();
			rayTestInfo.target = this;
			
			for each(var subMesh:SubMesh in mesh.subMeshes){
				if(subMesh.testRay(localRay, boneStateGroup, rayTestInfo)){
					result.push(rayTestInfo);
					return;
				}
			}
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
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			boneAttachmentGroup.onUpdate(timeElapsed);
			if(null == skeleton){
				return;
			}
			
			boneStateGroup.advanceTime(timeElapsed * 0.001);
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.animation = skeleton.getAnimationByName(value);
		}
	}
}