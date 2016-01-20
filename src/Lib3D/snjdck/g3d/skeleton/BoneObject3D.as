package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.g3d.parser.Geometry;
	import snjdck.model3d.calcVertexBound;
	
	use namespace ns_g3d;
	
	public class BoneObject3D extends DisplayObjectContainer3D
	{
		internal var initTransform:Transform;
		internal var transformGlobalToLocal:Transform;
		internal var entity:Entity;
		
		private var isKeyFrameDirty:Boolean;
		private const _keyFrame:Transform = new Transform();
		
		private var isTransformDirty:Boolean;
		
		private var isGlobalToGlobalDirty:Boolean;
		private var isGlobalToLocalDirty:Boolean;
		private const transformGlobalToGlobal:Transform = new Transform();
		private const transformLocalToGlobal:Transform = new Transform();
		
		public function BoneObject3D(){}
		
		private function get keyFrame():Transform
		{
			if(isKeyFrameDirty){
				entity.animation.getTransform(id, entity.animationTime, _keyFrame);
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
		
		override public function onUpdate(timeElapsed:int):void
		{
			isKeyFrameDirty = true;
			isGlobalToGlobalDirty = true;
			isGlobalToLocalDirty = true;
			isTransformDirty = true;
			super.onUpdate(timeElapsed);
		}
		
		private function getBoneStateLocal():Transform
		{
			if(isGlobalToLocalDirty){
				var parentBoneObject:BoneObject3D = parent as BoneObject3D;
				if(parentBoneObject == null){
					transformLocalToGlobal.copyFrom(initTransform);
				}else{
					var parentTransform:Transform = parentBoneObject.getBoneStateLocal();
					parentTransform.prepend(initTransform, transformLocalToGlobal);
				}
				transformLocalToGlobal.prepend(keyFrame, transformLocalToGlobal);
				isGlobalToLocalDirty = false;
			}
			return transformLocalToGlobal;
		}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal():Transform
		{
			if(isGlobalToGlobalDirty){
				getBoneStateLocal().prepend(transformGlobalToLocal, transformGlobalToGlobal);
				isGlobalToGlobalDirty = false;
			}
			return transformGlobalToGlobal;
		}
		
		public function addVertex(geometry:Geometry):void
		{
			var posData:Vector.<Number> = geometry.getPosData();
			var vertexList:Array = geometry.boneData.getVertexListByBoneId(id);
			for(var i:int=0, n:int=vertexList.length; i<n; i+=2){
				var vertexIndex:int = vertexList[i];
				posData.push(posData[vertexIndex], posData[vertexIndex+1], posData[vertexIndex+2]);
			}
			transformGlobalToLocal.transformVectors(posData, posData);
			calcVertexBound(posData, originalBound);
			markOriginalBoundDirty();
		}
		
		private const posData:Vector.<Number> = new Vector.<Number>();
	}
}