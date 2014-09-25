package snjdck.g3d.skeleton
{
	public class BoneStateGroup
	{
		private const boneGlobalStateList:Array = [];
		private const boneLocalStateList:Array = [];
		
		public function BoneStateGroup(){}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal(boneId:int):Transform
		{
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
			if(null == boneLocalStateList[boneId]){
				boneLocalStateList[boneId] = new Transform();
			}
			return boneLocalStateList[boneId];
		}
	}
}