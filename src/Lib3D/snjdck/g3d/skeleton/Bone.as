package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Quaternion;
	
	use namespace ns_g3d;

	final public class Bone
	{
		public var name:String;
		public var id:int;
		public var parentId:int = -1;
		
		ns_g3d var transform:Transform;
		private var keyFrame:Transform;
		
		private var nextSibling:Bone;
		private var firstChild:Bone;
		
		private var derivedOrientation:Quaternion;
		private var derivedPosition:Vector3D;
		
		internal var matrixGlobalToLocal:Matrix3D;
		
		public function Bone(name:String, id:int)
		{
			this.name = name;
			this.id = id;
			
			transform = new Transform();
			keyFrame = new Transform();
			
			derivedOrientation = new Quaternion();
			derivedPosition = new Vector3D();
			
			matrixGlobalToLocal = new Matrix3D();
		}
		
		ns_g3d function onInit(parentRotation:Quaternion, parentTranslation:Vector3D):void
		{
			parentRotation.rotateVector(transform.translation, derivedPosition);
			derivedPosition.incrementBy(parentTranslation);
			parentRotation.multiply(transform.rotation, derivedOrientation);
			
			derivedOrientation.toMatrix(matrixGlobalToLocal, derivedPosition);
			matrixGlobalToLocal.invert();
			
			if(nextSibling){
				nextSibling.onInit(parentRotation, parentTranslation);
			}
			
			if(firstChild){
				firstChild.onInit(derivedOrientation, derivedPosition);
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
		
		ns_g3d function updateMatrix(parentRotation:Quaternion, parentTranslation:Vector3D, boneStateGroup:BoneStateGroup):void
		{
			parentRotation.rotateVector(transform.translation, derivedPosition);
			derivedPosition.incrementBy(parentTranslation);
			parentRotation.multiply(transform.rotation, derivedOrientation);
			
			derivedOrientation.rotateVector(keyFrame.translation, tempVector);
			derivedPosition.incrementBy(tempVector);
			derivedOrientation.multiply(keyFrame.rotation, derivedOrientation);
			
			derivedOrientation.toMatrix(boneStateGroup.getBoneMatrix(id), derivedPosition);
			
			if(nextSibling){
				nextSibling.updateMatrix(parentRotation, parentTranslation, boneStateGroup);
			}
			
			if(firstChild){
				firstChild.updateMatrix(derivedOrientation, derivedPosition, boneStateGroup);
			}
		}
		
		ns_g3d function calculateKeyFrame(ani:Animation, time:Number):void
		{
			ani.getTransform(id, time, keyFrame);
			
			if(nextSibling){
				nextSibling.calculateKeyFrame(ani, time);
			}
			
			if(firstChild){
				firstChild.calculateKeyFrame(ani, time);
			}
		}
		/*
		internal function copyBoneMatrix(output:Matrix3D):void
		{
			output.copyFrom(matrixGlobalToLocal);	//世界 -> 局部
			output.append(matrixLocalToGlobal);		//局部 -> 世界
		}
		*/
		static private const tempVector:Vector3D = new Vector3D();
	}
}