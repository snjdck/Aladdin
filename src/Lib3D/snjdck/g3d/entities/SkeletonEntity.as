package snjdck.g3d.entities
{
	import array.del;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneAttachments;
	import snjdck.g3d.skeleton.BoneAttachmentsGroup;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.IBoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;
	
	public class SkeletonEntity extends Object3D implements IDrawUnit3D, IBoneStateGroup
	{
		private var mesh:Mesh;
		private var skeleton:Skeleton;
		
		private const boneStateGroup:BoneStateGroup = new BoneStateGroup();
		private const boneAttachmentsGroup:BoneAttachmentsGroup = new BoneAttachmentsGroup();
		private var isBoneStateDirty:Boolean;
		
		private var meshList:Array = [];
		
		public function SkeletonEntity(mesh:Mesh)
		{
			this.mesh = mesh;
			this.skeleton = mesh.skeleton;
			aniName = skeleton.getAnimationNames()[0];
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			isBoneStateDirty = true;
			boneStateGroup.stepAnimation(timeElapsed * 0.001);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(collector.isInSight(null)){
				if(isBoneStateDirty){
					skeleton.updateBoneState(boneStateGroup);
					isBoneStateDirty = false;
				}
				collector.addDrawUnit(this);
				boneAttachmentsGroup.onBoneStateChanged(boneStateGroup);
				boneAttachmentsGroup.collectDrawUnit(collector);
			}
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldTransform);
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subMesh.draw(context3d, this);
			}
			for each(var otherMesh:Mesh in meshList){
				for each(var subMesh:SubMesh in otherMesh.subMeshes){
					subMesh.draw(context3d, this);
				}
			}
		}
		
		public function get shaderName():String
		{
			return ShaderName.DYNAMIC_OBJECT;
		}
		
		public function getBoneState(boneId:int):Matrix4x4
		{
			return null;
		}
		
		private function getBoneAttachments(boneName:String):BoneAttachments
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone)
				throw new Error("boneName '" + boneName + "' not exist!");
			return boneAttachmentsGroup.getAttachments(bone.id);
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			getBoneAttachments(boneName).addAttachment(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			getBoneAttachments(boneName).removeAttachment(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			getBoneAttachments(boneName).removeAllAttachments();
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.changeAnimation(skeleton.getAnimationByName(value));
//			animationInstance.animation = skeleton.getAnimationByName(value);
		}
		
		public function addMesh(mesh:Mesh):void
		{
//			meshGroup.addMesh(mesh);
			meshList.push(mesh);
		}
		
		public function removeMesh(mesh:Mesh):void
		{
			array.del(meshList, mesh);
//			meshGroup.removeMesh(mesh);
		}
		
		public function calculateBound(result:AABB):void
		{
			result.clear();
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subMesh.mergeSubMeshBound(result);
			}
			for each(var otherMesh:Mesh in meshList){
				for each(var subMesh:SubMesh in otherMesh.subMeshes){
					subMesh.mergeSubMeshBound(result);
				}
			}
		}
		
		public function hideSubMeshAt(index:int):void
		{
//			meshGroup.hideSubMeshAt(index);
		}
	}
}