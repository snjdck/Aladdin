package snjdck.g3d.skeleton
{
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.obj3d.Entity;

	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		public const transform:Transform = new Transform();
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		private const transformGlobalToLocal:Transform = new Transform();
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
		}
		
		internal function createObject3D(entity:Entity, parent:DisplayObjectContainer3D):void
		{
			var boneObject:BoneObject3D = new BoneObject3D();
			boneObject.id = id;
			boneObject.name = name;
			boneObject.entity = entity;
			boneObject.initTransform.copyFrom(transform);
			boneObject.transformGlobalToLocal = transformGlobalToLocal;
			parent.addChild(boneObject);
			if(nextSibling){
				nextSibling.createObject3D(entity, parent);
			}
			if(firstChild){
				firstChild.createObject3D(entity, boneObject);
			}
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
	}
}