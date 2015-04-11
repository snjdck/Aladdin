package snjdck.g3d.skeleton
{
	import snjdck.g3d.ns_g3d;

	use namespace ns_g3d;
	
	public class BoneStateGroup
	{
		public var skeleton:Skeleton;
		public var animation:Animation;
		private var _animationTime:Number;
		private var isDirty:Boolean;
		
		private const boneGlobalStateList:Array = [];
		private const boneLocalStateList:Array = [];
		
		public function BoneStateGroup()
		{
			_animationTime = 0;
		}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal(boneId:int):Transform
		{
			onUpdate();
			if(null == boneGlobalStateList[boneId]){
				boneGlobalStateList[boneId] = new Transform();
			}
			return boneGlobalStateList[boneId];
		}
		
		/**
		 * 返回顶点的变换(局部到全局)
		 */
		public function getBoneStateLocal(boneId:int):Transform
		{
			onUpdate();
			if(null == boneLocalStateList[boneId]){
				boneLocalStateList[boneId] = new Transform();
			}
			return boneLocalStateList[boneId];
		}
		
		private function onUpdate():void
		{
			if(isDirty){
				isDirty = false;
				skeleton.onUpdate(animation, _animationTime, this);
			}
		}

		public function advanceTime(value:Number):void
		{
			_animationTime += value;
			if(_animationTime > animation.length){
				_animationTime -= animation.length;
			}
			isDirty = true;
		}
	}
}