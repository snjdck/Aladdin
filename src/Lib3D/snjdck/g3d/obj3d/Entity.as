package snjdck.g3d.obj3d
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.BoneObject3D;
	import snjdck.g3d.skeleton.IBoneStateGroup;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.g3d.skeleton.Transform;
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
		
		public function Entity(mesh:Mesh)
		{
			blendMode = BlendMode.NORMAL;
			
			for(var i:int=0; i<mesh.subMeshes.length; ++i){
				var subMesh:SubMesh = mesh.subMeshes[i];
				addChild(new SubEntity(subMesh));
			}
			
			hasSkeleton = (mesh.skeleton != null);
			
			if(hasSkeleton){
				skeleton = mesh.skeleton;
				aniName = skeleton.getAnimationNames()[0];
				skeleton.createObject3D(this);
			}
		}
		
		public function getBoneState(boneId:int):Transform
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
		
		private function getBoneObject(boneName:String):DisplayObjectContainer3D
		{
			var bone:Bone = skeleton.getBoneByName(boneName);
			if(null == bone){
				throw new Error("boneName '" + boneName + "' not exist!");
			}
			return boneStateGroup[bone.id];
//			var boneObject:DisplayObjectContainer3D = boneDict[boneName];
//			if(boneObject == null){
//				boneObject = new DisplayObjectContainer3D();
//				addChild(boneObject);
//				boneObject.id = bone.id;
//				boneDict[boneName] = boneObject;
//			}
//			return boneObject;
		}
		
		public function bindEntityToBone(boneName:String, entity:Object3D):void
		{
			getBoneObject(boneName).addChild(entity);
		}
		
		public function unbindEntityFromBone(boneName:String, entity:Entity):void
		{
			getBoneObject(boneName).removeChild(entity);
		}
		
		public function unbindAllEntitiesFromBone(boneName:String):void
		{
			var boneObject:DisplayObjectContainer3D = getBoneObject(boneName);
			for(var i:int=boneObject.numChildren-1; i>=0; --i){
				if(boneObject.getChildAt(i) is Entity){
					boneObject.removeChildAt(i);
				}else{
					break;
				}
			}
		}
		/*
		public function shareSkeletonInstanceWith(entity:Entity):void
		{
			skeleton = null;
			boneStateGroup = entity.boneStateGroup;
		}
		*/
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			updateBoneState(timeElapsed);
			/*
			for each(var boneObject:DisplayObjectContainer3D in boneDict){
				if(boneObject.numChildren <= 0)
					continue;
				var matrix:Matrix3D = boneObject.transform;
				boneStateGroup.getBoneStateLocal(boneObject.id).toMatrix(matrix);
				boneObject.transform = matrix;
			}
			*/
		}
		
		public function set aniName(value:String):void
		{
			animation = skeleton.getAnimationByName(value);
		}
		//*
		public function updateBoneState(timeElapsed:int):void
		{
			if(skeleton != null){
				animationTime += timeElapsed * 0.001;
				if(animationTime > animation.length){
					animationTime -= animation.length;
				}
			}
		}
		//*/
		public function addMesh(child:Mesh):void
		{
			var i:int;
			for(i=numChildren-1; i>=0; --i){
				if(getChildAt(i).userData === child){
					return;
				}
			}
			for(i=0; i<child.subMeshes.length; ++i){
				var subMesh:SubMesh = child.subMeshes[i];
				var subEntity:SubEntity = new SubEntity(subMesh);
				subEntity.userData = child;
				addChild(subEntity);
			}
		}
		
		public function removeMesh(child:Mesh):void
		{
			for(var i:int=numChildren-1; i>=0; --i){
				if(getChildAt(i).userData === child){
					removeChildAt(i);
				}
			}
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
			var subEntity:Object3D = getChildAt(index);
			if(subEntity != null){
				subEntity.visible = false;
			}
		}
	}
}