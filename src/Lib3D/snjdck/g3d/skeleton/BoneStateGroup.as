package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;

	public class BoneStateGroup
	{
		private var boneMatrixList:Array;
		
		public function BoneStateGroup()
		{
			boneMatrixList = [];
		}
		
		public function getBoneMatrix(boneId:int):Matrix3D
		{
			if(null == boneMatrixList[boneId]){
				boneMatrixList[boneId] = new Matrix3D();
			}
			return boneMatrixList[boneId];
		}
		
		public function prependBoneTransform(skeleton:Skeleton):void
		{
			const boneCount:int = boneMatrixList.length;
			for(var boneId:int=0; boneId<boneCount; ++boneId){
				var boneMatrix:Matrix3D = boneMatrixList[boneId];
				if(null == boneMatrix){
					continue;
				}
				var bone:Bone = skeleton.getBoneById(boneId);
				boneMatrix.prepend(bone.matrixGlobalToLocal);
			}
		}
	}
}