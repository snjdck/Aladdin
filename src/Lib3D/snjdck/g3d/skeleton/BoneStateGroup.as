package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	
	use namespace ns_g3d;
	
	public class BoneStateGroup
	{
		public var loopMode:int;
		
		ns_g3d var skeleton:Skeleton;
		ns_g3d var animation:Animation;
		ns_g3d var position:Number;
		
		public var isDirty:Boolean;
		
		private const boneStateDict:Array = [];
		
		public function BoneStateGroup(skeleton:Skeleton)
		{
			this.skeleton = skeleton;
			position = 0;
		}
		
		public function changeAnimation(animationName:String):void
		{
			var newAnimation:Animation = skeleton.getAnimationByName(animationName);
			if(animation != newAnimation){
				animation = newAnimation;
				position = 0;
				isDirty = true;
			}
		}
		
		public function stepAnimation(seconds:Number):void
		{
			if(animation.length <= 0 || animation.getKeyFrameCount() <= 1){
				return;
			}
			var newPosition:Number = position + seconds;
			while(newPosition > animation.length){
				newPosition -= animation.length;
			}
			if(position != newPosition){
				position = newPosition;
				isDirty = true;
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