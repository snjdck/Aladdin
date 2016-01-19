package snjdck.g3d.skeleton
{
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.obj3d.Entity;
	
	public class BoneObject3D extends DisplayObjectContainer3D
	{
		public const initTransform:Transform = new Transform();
		private const keyFrame:Transform = new Transform();
		public var entity:Entity;
		
		private var isKeyFrameDirty:Boolean;
		private var isGlobalToGlobalDirty:Boolean;
		public const transformGlobalToGlobal:Transform = new Transform();
		public const transformLocalToGlobal:Transform = new Transform();
		internal var transformGlobalToLocal:Transform;
		
		public function BoneObject3D(){}
		
		private function get parentTransform():Transform
		{
			var parentBoneObject:BoneObject3D = parent as BoneObject3D;
			if(parentBoneObject != null){
				return parentBoneObject.transformLocalToGlobal;
			}
			return null;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			isKeyFrameDirty = true;
			entity.animation.getTransform(id, entity.animationTime, keyFrame);
			
			if(null == parentTransform){
				transformLocalToGlobal.copyFrom(initTransform);
			}else{
				parentTransform.prepend(initTransform, transformLocalToGlobal);
			}
			
			transformLocalToGlobal.prepend(keyFrame, transformLocalToGlobal);
			
			transformLocalToGlobal.toMatrix(transform);
			transform = transform;
			markOriginalBoundDirty();
			
			isGlobalToGlobalDirty = true;
			
			super.onUpdate(timeElapsed);
		}
		
		/**
		 * 返回顶点的变换(全局到局部,再局部到全局)
		 */
		public function getBoneStateGlobal():Transform
		{
			if(isGlobalToGlobalDirty){
				transformLocalToGlobal.prepend(transformGlobalToLocal, transformGlobalToGlobal);
				isGlobalToGlobalDirty = false;
			}
			return transformGlobalToGlobal;
		}
		
		/**
		 * 返回顶点的变换(局部到全局)
		 */
		public function getBoneStateLocal():Transform
		{
			return transformLocalToGlobal;
		}
	}
}