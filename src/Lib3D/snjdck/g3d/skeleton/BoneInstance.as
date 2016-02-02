package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.parser.Geometry;
	import snjdck.model3d.calcVertexBound;
	
	use namespace ns_g3d;
	
	public class BoneInstance extends DisplayObjectContainer3D
	{
		internal var initTransform:Matrix4x4;
		internal var boneWorldToLocal:Matrix4x4;
		internal var boneWorldToLocalMatrix:Matrix3D;
		internal var animationInstance:AnimationInstance;
		
		private var isBoneDirty:Boolean;
		private const boneWorldToWorld:Matrix4x4 = new Matrix4x4();
		private const boneLocalToWorld:Matrix4x4 = new Matrix4x4();
		
		ns_g3d const attachmentGroup:BoneAttachmentGroup = new BoneAttachmentGroup(this);
		
		public function BoneInstance(){}
		
		override public function onUpdate(timeElapsed:int):void
		{
			animationInstance.getKeyFrame(id, boneLocalToWorld);
			initTransform.prepend(boneLocalToWorld, boneLocalToWorld);
			boneLocalToWorld.toMatrix(transform);
			var parentBoneObject:BoneInstance = parent as BoneInstance;
			if(parentBoneObject != null)
				parentBoneObject.boneLocalToWorld.prepend(boneLocalToWorld, boneLocalToWorld);
			markWorldMatrixDirty();
			isBoneDirty = true;
			super.onUpdate(timeElapsed);
		}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal():Matrix4x4
		{
			if(isBoneDirty){
				boneLocalToWorld.prepend(boneWorldToLocal, boneWorldToWorld);
				isBoneDirty = false;
			}
			return boneWorldToWorld;
		}
		
		public function addVertex(geometry:Geometry):void
		{
			var vertexList:Array = geometry.boneData.getVertexListByBoneId(id);
			if(vertexList == null || vertexList.length <= 0){
				return;
			}
			var vertexPosData:Vector.<Number> = geometry.getPosData();
			for(var i:int=0, n:int=vertexList.length; i<n; i+=2){
				var vertexIndex:int = vertexList[i];
				posData.push(vertexPosData[vertexIndex], vertexPosData[vertexIndex+1], vertexPosData[vertexIndex+2]);
			}
			boneWorldToLocalMatrix.transformVectors(posData, posData);
			calcVertexBound(posData, tempBound);
			defaultBound.merge(tempBound);
//			markOriginalBoundDirty();
		}
		
		public function mergeBoneBound(result:AABB):void
		{
			boneLocalToWorld.toMatrix(tempMatrix);
			defaultBound.transform(tempMatrix, tempBound);
			result.merge(tempBound);
		}
		
		static private const tempBound:AABB = new AABB();
		private const defaultBound:AABB = new AABB();
		static private const tempMatrix:Matrix3D = new Matrix3D();
		private const posData:Vector.<Number> = new Vector.<Number>();
	}
}