package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	
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
			rootBone.onInit(null);
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
			return $dict.getNumKeys(animationDict);
		}
		
		public function getAnimationNames():Array
		{
			return $dict.getKeys(animationDict);
		}
		
		public function updateBoneState(boneStateGroup:BoneStateGroup):void
		{
			rootBone.updateState(null, boneStateGroup);
		}
	}
}