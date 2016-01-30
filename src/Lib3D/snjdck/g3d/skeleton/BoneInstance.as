package snjdck.g3d.skeleton
{
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
		internal var transformGlobalToLocal:Matrix4x4;
		internal var animationInstance:AnimationInstance;
		
		private const keyFrame:Matrix4x4 = new Matrix4x4();
		
		private var isGlobalToGlobalDirty:Boolean;
		private var isGlobalToLocalDirty:Boolean;
		private const transformGlobalToGlobal:Matrix4x4 = new Matrix4x4();
		private const transformLocalToGlobal:Matrix4x4 = new Matrix4x4();
		
		ns_g3d const attachmentGroup:BoneAttachmentGroup = new BoneAttachmentGroup(this);
		
		public function BoneInstance(){}
		/*
		private function get keyFrame():Matrix4x4
		{
			if(isKeyFrameDirty){
				animationInstance.getKeyFrame(id, _keyFrame);
				isKeyFrameDirty = false;
			}
			return _keyFrame;
		}
		
		override public function get transform():Matrix3D
		{
			var result:Matrix3D = super.transform;
			if(isTransformDirty){
				initTransform.prepend(keyFrame, transformLocalToGlobal);
				transformLocalToGlobal.toMatrix(result);
				isTransformDirty = false;
			}
			return result;
		}
		*/
		override public function onUpdate(timeElapsed:int):void
		{
			animationInstance.getKeyFrame(id, keyFrame);
			initTransform.prepend(keyFrame, transformLocalToGlobal);
			transformLocalToGlobal.toMatrix(transform);
			var parentBoneObject:BoneInstance = parent as BoneInstance;
			if(parentBoneObject != null)
				parentBoneObject.transformLocalToGlobal.prepend(transformLocalToGlobal, transformLocalToGlobal);
			transformLocalToGlobal.prepend(transformGlobalToLocal, transformGlobalToGlobal);
			markWorldMatrixDirty();
			super.onUpdate(timeElapsed);
		}
		
		private function getBoneStateLocal():Matrix4x4
		{
			/*
			if(isGlobalToLocalDirty){
				var parentBoneObject:BoneInstance = parent as BoneInstance;
				if(parentBoneObject == null){
					transformLocalToGlobal.copyFrom(initTransform);
				}else{
					var parentTransform:Matrix4x4 = parentBoneObject.getBoneStateLocal();
					parentTransform.prepend(initTransform, transformLocalToGlobal);
				}
				transformLocalToGlobal.prepend(keyFrame, transformLocalToGlobal);
				isGlobalToLocalDirty = false;
			}
			*/
			return transformLocalToGlobal;
		}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal():Matrix4x4
		{
			/*
			if(isGlobalToGlobalDirty){
				getBoneStateLocal().prepend(transformGlobalToLocal, transformGlobalToGlobal);
				isGlobalToGlobalDirty = false;
			}
			*/
			return transformGlobalToGlobal;
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
			transformGlobalToLocal.transformVectors(posData, posData);
			calcVertexBound(posData, defaultBound);
//			markOriginalBoundDirty();
		}
		
		private const defaultBound:AABB = new AABB();
		private const posData:Vector.<Number> = new Vector.<Number>();
	}
}