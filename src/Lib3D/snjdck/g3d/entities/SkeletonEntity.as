package snjdck.g3d.entities
{
	import flash.geom.Matrix3D;
	
	import array.del;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.shader.ShaderName;
	
	use namespace ns_g3d;
	
	public class SkeletonEntity extends DisplayObjectContainer3D implements IDrawUnit3D
	{
		private var mesh:Mesh;
		private var skeleton:Skeleton;
		
		private var boneStateGroup:BoneStateGroup;
		private var isBoneStateDirty:Boolean;
		
		public const worldBound:AABB = new AABB();
		public const bound:AABB = new AABB();
		
		private var meshList:Array = [];
		
		public function SkeletonEntity(mesh:Mesh)
		{
			this.mesh = mesh;
			this.skeleton = mesh.skeleton;
			boneStateGroup = new BoneStateGroup(skeleton);
			aniName = skeleton.getAnimationNames()[0];
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			isBoneStateDirty = true;
			boneStateGroup.stepAnimation(timeElapsed * 0.001);
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			bound.transform(worldTransform, worldBound);
			if(collector.isInSight(worldBound)){
//				if(isBoneStateDirty){
					skeleton.updateBoneState(boneStateGroup);
//					isBoneStateDirty = false;
//				}
				collector.addDrawUnit(this);
				onBoneStateChanged();
				super.collectDrawUnit(collector);
			}
		}
		
		private function onBoneStateChanged():void
		{
			for(var i:int=0, n:int=numChildren; i<n; ++i){
				var attachments:Object3D = getChildAt(i);
				var boneState:Matrix4x4 = boneStateGroup.getBoneStateLocal(attachments.id);
				boneState.toMatrix(boneMatrix);
				attachments.transform = boneMatrix;
			}
		}
		
		static private const boneMatrix:Matrix3D = new Matrix3D();
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVcM(Geometry.WORLD_MATRIX_OFFSET, worldTransform);
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subMesh.draw(context3d, boneStateGroup);
			}
			for each(var otherMesh:Mesh in meshList){
				for each(var subMesh:SubMesh in otherMesh.subMeshes){
					subMesh.draw(context3d, boneStateGroup);
				}
			}
		}
		
		public function get shaderName():String
		{
			return ShaderName.DYNAMIC_OBJECT;
		}
		
		private function getBoneAttachments(boneName:String):DisplayObjectContainer3D
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone)
				throw new Error("boneName '" + boneName + "' not exist!");
			var attachments:Object3D = getChildById(bone.id);
			if(null == attachments){
				attachments = new DisplayObjectContainer3D();
				attachments.id = bone.id;
				addChild(attachments);
			}
			return attachments as DisplayObjectContainer3D;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			getBoneAttachments(boneName).addChild(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			getBoneAttachments(boneName).removeChild(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			getBoneAttachments(boneName).removeAllChildren();
		}
		
		public function set aniName(value:String):void
		{
			boneStateGroup.changeAnimation(value);
//			animationInstance.animation = skeleton.getAnimationByName(value);
		}
		
		public function addMesh(mesh:Mesh):void
		{
//			meshGroup.addMesh(mesh);
			meshList.push(mesh);
			calculateBound(bound);
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