package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	
	use namespace ns_g3d;
	
	public class BoneStateGroup implements IBoneStateGroup
	{
		public var loopMode:int;
		
		private var animation:Animation;
		private var position:Number;
		
		public function BoneStateGroup()
		{
			position = 0;
		}
		
		public function changeAnimation(newAnimation:Animation):void
		{
			animation = newAnimation;
			position = 0;
		}
		
		public function stepAnimation(seconds:Number):void
		{
			position += seconds;
			if(position > animation.length){
				position -= animation.length;
			}
		}
		
		public function getBoneState(boneId:int):Matrix4x4
		{
			return getBoneStateWorld(boneId);
		}
		
		public function getBoneStateWorld(boneId:int):Matrix4x4
		{
			return null;
		}
		
		public function getBoneStateLocal(boneId:int):Matrix4x4
		{
			return null;
		}
		
		public function getKeyFrame(boneId:int, result:Matrix4x4):void
		{
			animation.getTransform(boneId, position, result);
		}
	}
}