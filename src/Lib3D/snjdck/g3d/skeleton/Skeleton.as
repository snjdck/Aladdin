package snjdck.g3d.skeleton
{
	import flash.geom.Vector3D;
	
	import dict.getNumKeys;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Quaternion;
	
	use namespace ns_g3d;

	public class Skeleton
	{
		private var animationDict:Object;
		private var boneList:Array;
		private var rootBone:Bone;
		
		public function Skeleton()
		{
			animationDict = {};
			boneList = [];
		}
		
		ns_g3d function addBone(bone:Bone):void
		{
			boneList[bone.id] = bone;
		}
		
		ns_g3d function setBoneParent(boneId:int, boneParentId:int):void
		{
			getBoneById(boneId).parentId = boneParentId;
		}
		
		ns_g3d function onInit():void
		{
			for each(var bone:Bone in boneList){
				var boneParent:Bone = getBoneById(bone.parentId);
				if(boneParent){
					boneParent.addChild(bone);
				}else if(rootBone){
					rootBone.addSibling(bone);
				}else{
					rootBone = bone;
				}
			}
			rootBone.onInit(Quaternion.Null, NullVector);
		}
		
		public function get numBones():int
		{
			return boneList.length;
		}
		
		public function getBoneById(id:int):Bone
		{
			return boneList[id];
		}
		
		public function getBoneByName(boneName:String):Bone
		{
			for each(var bone:Bone in boneList){
				if(bone.name == boneName){
					return bone;
				}
			}
			return null;
		}
		
		ns_g3d function getBoneNames():Array
		{
			var result:Array = [];
			
			for each(var bone:Bone in boneList){
				result.push(bone.name);
			}
			
			return result.sort();
		}
		
		ns_g3d function addAnimation(animation:Animation):void
		{
			animationDict[animation.name] = animation;
		}
		
		ns_g3d function getAnimationByName(name:String):Animation
		{
			return animationDict[name];
		}
		
		public function getAnimationLength(name:String):Number
		{
			return getAnimationByName(name).length;
		}
		
		public function getAnimationAmount():int
		{
			return dict.getNumKeys(animationDict);
		}
		
		public function getAnimationNames():Array
		{
			return dict.getKeys(animationDict);
		}
		
		ns_g3d function onUpdate(aniName:String, time:Number, boneStateGroup:BoneStateGroup):void
		{
			rootBone.calculateKeyFrame(getAnimationByName(aniName), time);
			rootBone.updateMatrix(Quaternion.Null, NullVector, boneStateGroup);
		}
		
		static private const NullVector:Vector3D = new Vector3D();
	}
}