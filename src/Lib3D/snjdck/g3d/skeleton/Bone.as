package snjdck.g3d.skeleton
{
	import snjdck.g3d.core.DisplayObjectContainer3D;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.obj3d.Entity;

	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		public const transform:Matrix4x4 = new Matrix4x4();
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		private const transformGlobalToLocal:Matrix4x4 = new Matrix4x4();
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
		}
		
		internal function createObject3D(entity:Entity, parent:DisplayObjectContainer3D):void
		{
			var boneObject:BoneInstance = new BoneInstance();
			boneObject.id = id;
			boneObject.name = name;
			boneObject.animationInstance = entity.animationInstance;
			entity.regBone(boneObject);
			boneObject.initTransform = transform;
			boneObject.boneWorldToLocal = transformGlobalToLocal;
			parent.addChild(boneObject);
			if(nextSibling){
				nextSibling.createObject3D(entity, parent);
			}
			if(firstChild){
				firstChild.createObject3D(entity, boneObject);
			}
		}
		
		internal function onInit(parentTransform:Matrix4x4):void
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