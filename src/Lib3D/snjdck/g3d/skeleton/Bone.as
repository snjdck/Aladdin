package snjdck.g3d.skeleton
{
	import snjdck.g3d.geom.Matrix4x4;

	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		public const transform:Matrix4x4 = new Matrix4x4();
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		internal const transformWorldToLocal:Matrix4x4 = new Matrix4x4();
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
		}
		
		internal function onInit(parentTransform:Matrix4x4):void
		{
			if(null == parentTransform){
				transformWorldToLocal.copyFrom(transform);
			}else{
				parentTransform.prepend(transform, transformWorldToLocal);
			}
			
			if(nextSibling){
				nextSibling.onInit(parentTransform);
			}
			if(firstChild){
				firstChild.onInit(transformWorldToLocal);
			}
			
			transformWorldToLocal.invert();
		}
		
		internal function updateState(parentTransform:Matrix4x4, boneStateGroup:BoneStateGroup):void
		{
			var transformLocalToWorld:Matrix4x4 = boneStateGroup.getBoneStateLocal(id);
			boneStateGroup.getKeyFrame(id, transformLocalToWorld);
			transform.prepend(transformLocalToWorld, transformLocalToWorld);
			if(parentTransform != null){
				parentTransform.prepend(transformLocalToWorld, transformLocalToWorld);
			}
			
			if(nextSibling){
				nextSibling.updateState(parentTransform, boneStateGroup);
			}
			if(firstChild){
				firstChild.updateState(transformLocalToWorld, boneStateGroup);
			}
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
	}
}