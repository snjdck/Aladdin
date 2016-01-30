package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;

	use namespace ns_g3d;
	
	public class AnimationInstance
	{
		private var animation:Animation;
		private var time:Number;
		
		public function AnimationInstance(animation:Animation)
		{
			this.animation = animation;
			this.time = 0;
		}
		
		public function hasAnimation():Boolean
		{
			return animation != null && animation.length > 0;
		}
		
		public function update(timeElapsed:int):void
		{
			time += timeElapsed * 0.001;
			if(time > animation.length){
				time -= animation.length;
			}
		}
		
		public function getKeyFrame(boneId:int, result:Matrix4x4):void
		{
			animation.getTransform(boneId, time, result);
		}
	}
}