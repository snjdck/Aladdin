package snjdck.g3d.skeleton
{
	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		public const transform:Transform = new Transform();
		private var keyFrame:Transform;
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		private const transformGlobalToLocal:Transform = new Transform();
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
			
			keyFrame = new Transform();
		}
		
		internal function onInit(parentTransform:Transform):void
		{
			if(null == parentTransform){
				transformGlobalToLocal.copyFrom(transform);
			}else{
				parentTransform.prepend(transform, transformGlobalToLocal);
			}
			
			if(nextSibling){
				nextSibling.onInit(parentTransform);
			}
			if(firstChild){
				firstChild.onInit(transformGlobalToLocal);
			}
			
			transformGlobalToLocal.invert();
		}
		
		internal function addChild(child:Bone):void
		{
			if(firstChild){
				firstChild.addSibling(child);
			}else{
				firstChild = child;
			}
		}
		
		internal function addSibling(bone:Bone):void
		{
			var test:Bone = this;
			while(test.nextSibling){
				test = test.nextSibling;
			}
			test.nextSibling = bone;
		}
		
		internal function updateMatrix(parentTransform:Transform, boneStateGroup:BoneStateGroup):void
		{
			var transformLocalToGlobal:Transform = boneStateGroup.getBoneStateLocal(id);
			if(null == parentTransform){
				transformLocalToGlobal.copyFrom(transform);
			}else{
				parentTransform.prepend(transform, transformLocalToGlobal);
			}
			
			transformLocalToGlobal.prepend(keyFrame, transformLocalToGlobal);
			transformLocalToGlobal.prepend(transformGlobalToLocal, boneStateGroup.getBoneStateGlobal(id));
			
			if(nextSibling){
				nextSibling.updateMatrix(parentTransform, boneStateGroup);
			}
			if(firstChild){
				firstChild.updateMatrix(transformLocalToGlobal, boneStateGroup);
			}
		}
		
		internal function calculateKeyFrame(ani:Animation, time:Number):void
		{
			ani.getTransform(id, time, keyFrame);
			
			if(nextSibling){
				nextSibling.calculateKeyFrame(ani, time);
			}
			if(firstChild){
				firstChild.calculateKeyFrame(ani, time);
			}
		}
	}
}