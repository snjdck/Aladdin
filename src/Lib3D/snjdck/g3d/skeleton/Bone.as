package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	
	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		public const transform:Transform = new Transform();
		private var keyFrame:Transform;
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		private var derivedTransform:Transform;
		
		internal var matrixGlobalToLocal:Matrix3D;
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
			
			keyFrame = new Transform();
			
			derivedTransform = new Transform();
			matrixGlobalToLocal = new Matrix3D();
		}
		
		internal function onInit(parentTransform:Transform):void
		{
			if(null == parentTransform){
				derivedTransform.copyFrom(transform);
			}else{
				parentTransform.concat(transform, derivedTransform);
			}
			
			derivedTransform.toMatrix(matrixGlobalToLocal);
			matrixGlobalToLocal.invert();
			
			if(nextSibling){
				nextSibling.onInit(parentTransform);
			}
			if(firstChild){
				firstChild.onInit(derivedTransform);
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
		
		internal function updateMatrix(parentTransform:Transform, boneStateGroup:BoneStateGroup):void
		{
			if(null == parentTransform){
				derivedTransform.copyFrom(transform);
			}else{
				parentTransform.concat(transform, derivedTransform);
			}
			
			derivedTransform.concat(keyFrame, derivedTransform);
			derivedTransform.toMatrix(boneStateGroup.getBoneMatrix(id));
			
			if(nextSibling){
				nextSibling.updateMatrix(parentTransform, boneStateGroup);
			}
			if(firstChild){
				firstChild.updateMatrix(derivedTransform, boneStateGroup);
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