package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;

	use namespace ns_g3d;
	
	public class AnimationInstance
	{
		private var _animation:Animation;
		private var time:Number = 0;
		
		public function AnimationInstance(){}
		
		public function hasAnimation():Boolean
		{
			return _animation != null && _animation.length > 0;
		}
		
		public function update(timeElapsed:int):void
		{
			time += timeElapsed * 0.001;
			if(time > _animation.length){
				time -= _animation.length;
			}
		}
		
		public function isDirty():Boolean
		{
			return true;
		}
		
		public function getKeyFrame(boneId:int, result:Matrix4x4):void
		{
			_animation.getTransform(boneId, time, result);
		}

		public function set animation(value:Animation):void
		{
			_animation = value;
		}
	}
}