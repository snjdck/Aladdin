package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.obj3d.Entity;
	
	use namespace ns_g3d;
	
	public class BoneObject3D extends DisplayObjectContainer3D
	{
		internal var initTransform:Transform;
		internal var transformGlobalToLocal:Transform;
		internal var entity:Entity;
		
		private var isKeyFrameDirty:Boolean;
		private const keyFrame:Transform = new Transform();
		
		private var isGlobalToGlobalDirty:Boolean;
		private const transformGlobalToGlobal:Transform = new Transform();
		private const transformLocalToGlobal:Transform = new Transform();
		
		private var flag:Boolean;
		
		public function BoneObject3D(){}
		
		private function get parentTransform():Transform
		{
			var parentBoneObject:BoneObject3D = parent as BoneObject3D;
			if(parentBoneObject != null){
				return parentBoneObject.getBoneStateLocal();
			}
			return null;
		}
		//*
		override public function get transform():Matrix3D
		{
			var result:Matrix3D = super.transform;
			if(flag){
				entity.animation.getTransform(id, entity.animationTime, keyFrame);
				initTransform.prepend(keyFrame, transformLocalToGlobal);
				transformLocalToGlobal.toMatrix(result);
				markOriginalBoundDirty();
				flag = false;
			}
			return result;
		}
		/*
		override public function get worldTransform():Matrix3D
		{
			var result:Matrix3D = super.worldTransform;
			result.copyFrom(transform);
			result.append(parent.worldTransform);
			return result;
		}
		//*/
		
		override public function onUpdate(timeElapsed:int):void
		{
			isKeyFrameDirty = true;
			isGlobalToGlobalDirty = true;
			flag = true;
			markWorldMatrixDirty();
			super.onUpdate(timeElapsed);
		}
		
		private function getBoneStateLocal():Transform
		{
//			transform = transform;
//			if(parentTransform != null){
//				parentTransform.prepend(transformLocalToGlobal, transformLocalToGlobal);
//			}
//			/*
			if(isKeyFrameDirty){
				entity.animation.getTransform(id, entity.animationTime, keyFrame);
				
				if(null == parentTransform){
					transformLocalToGlobal.copyFrom(initTransform);
				}else{
					parentTransform.prepend(initTransform, transformLocalToGlobal);
				}
				
				transformLocalToGlobal.prepend(keyFrame, transformLocalToGlobal);
				markOriginalBoundDirty();
				isKeyFrameDirty = false;
			}
//			*/
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
	}
}