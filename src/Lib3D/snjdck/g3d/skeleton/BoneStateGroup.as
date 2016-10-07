package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	
	use namespace ns_g3d;
	
	public class BoneStateGroup
	{
		public var loopMode:int;
		
		private var skeleton:Skeleton;
		private var animation:Animation;
		private var position:Number;
		
		private const boneStateDict:Array = [];
		
		public function BoneStateGroup(skeleton:Skeleton)
		{
			this.skeleton = skeleton;
			position = 0;
		}
		
		public function changeAnimation(animationName:String):void
		{
			animation = skeleton.getAnimationByName(animationName);
			position = 0;
		}
		
		public function stepAnimation(seconds:Number):void
		{
			position += seconds;
			if(position > animation.length){
				position -= animation.length;
			}
		}
		
		public function getBoneStateWorld(boneId:int, result:Matrix4x4):void
		{
			var boneState:Matrix4x4 = getBoneStateLocal(boneId);
			var bone:Bone = skeleton.getBoneById(boneId);
			boneState.prepend(bone.transform, result);
		}
		
		public function getBoneStateLocal(boneId:int):Matrix4x4
		{
			var boneState:Matrix4x4 = boneStateDict[boneId];
			if(null == boneState){
				boneState = new Matrix4x4();
				boneStateDict[boneId] = boneState;
			}
			return boneState;
		}
		
		public function getKeyFrame(boneId:int, result:Matrix4x4):void
		{
			animation.getTransform(boneId, position, result);
		}
	}
}