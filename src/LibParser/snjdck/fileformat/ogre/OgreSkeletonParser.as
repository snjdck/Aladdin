package snjdck.fileformat.ogre
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.fileformat.ogre.support.SkeletonChunkID;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.KeyFrame;
	import snjdck.g3d.skeleton.Skeleton;
	
	import stream.readCString;
	import stream.readVector3;
	
	use namespace ns_g3d;

	public class OgreSkeletonParser extends OgreParser
	{
		static public function Parse(ba:ByteArray):Skeleton
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var parser:OgreSkeletonParser = new OgreSkeletonParser(ba);
			parser.readSkeleton();
			return parser.skeleton;
		}
		
		public var skeleton:Skeleton;
		
		public function OgreSkeletonParser(ba:ByteArray)
		{
			super(ba);
			skeleton = new Skeleton();
		}
		
		private function readSkeleton():void
		{
			readHeader();
			
			readBones();
			readBoneHierarchy();
			readAnimations();
			
			while(buffer.bytesAvailable > 0){
				readUnknowChunk();
			}
			
			skeleton.onInit();
		}
		
		private function readBones():void
		{
			while(SkeletonChunkID.BONE == getChunkId())
			{
				var length:uint = getChunkDataSize();
				var bone:Bone = new Bone(readCString(buffer), buffer.readUnsignedShort());
				
				readVector3(buffer, bone.transform.translation);
				bone.transform.rotation.readFrom(buffer);
				
				if(length > 30){
//					readVector3(buffer, bone.transform.scale);
					buffer.position += 12;
					trace("skeleton need support scale!");
				}
//				trace(bone.name, bone.transform);
				skeleton.addBone(bone);
			}
		}
		
		private function readBoneHierarchy():void
		{
			while(SkeletonChunkID.BONE_PARENT == getChunkId()){
				seekToData();
				skeleton.setBoneParent(buffer.readUnsignedShort(), buffer.readUnsignedShort());
			}
		}
		
		private function readAnimations():void
		{
			while(SkeletonChunkID.ANIMATION == getChunkId()){
				seekToData();
				
				var animation:Animation = new Animation(readCString(buffer), buffer.readFloat());
				
				while(SkeletonChunkID.ANIMATION_TRACK == getChunkId()){
					seekToData();
					
					var boneId:int = buffer.readUnsignedShort();
					var keyFrames:Vector.<KeyFrame> = new Vector.<KeyFrame>();
					
					while(SkeletonChunkID.ANIMATION_TRACK_KEYFRAME == getChunkId()){
						readKeyFrame(keyFrames);
					}
					
					if(SkeletonChunkID.ANIMATION_TRACK_KEYFRAME_TLBB == getChunkId()){
						readKeyFrameTLBB(keyFrames);
					}
					
					animation.addTrack(boneId, keyFrames);
				}
				
				skeleton.addAnimation(animation);
			}
		}
		
		private function readKeyFrame(output:Vector.<KeyFrame>):void
		{
			var length:uint = getChunkDataSize();
			var keyFrame:KeyFrame = new KeyFrame(buffer.readFloat());
			output.push(keyFrame);
			
			keyFrame.transform.rotation.readFrom(buffer);
			readVector3(buffer, keyFrame.transform.translation);
			if(length > 32){
				buffer.position += 12;
				trace("skeleton need support scale!");
//				readVector3(buffer, keyFrame.transform.scale);
			}
//			trace("keyframe",output.length-1,keyFrame.transform);
		}
		
		/** 天龙八部 */
		private function readKeyFrameTLBB(output:Vector.<KeyFrame>):void
		{
			seekToData();
			
			var count:uint = buffer.readUnsignedShort();
			var flags:uint = buffer.readUnsignedShort();
			
			var hasRotation:Boolean = (flags & 1) != 0;
			var hasTranslation:Boolean = (flags & 2) != 0;
			var hasScale:Boolean = (flags & 4) != 0;
			
			for(var i:int=0; i<count; i++)
			{
				var keyFrame:KeyFrame = new KeyFrame(buffer.readFloat());
				
				if(hasRotation){
					keyFrame.transform.rotation.readFrom(buffer);
				}
				
				if(hasTranslation){
					readVector3(buffer, keyFrame.transform.translation);
				}
				
				if(hasScale){
					buffer.position += 12;
					trace("skeleton need support scale!");
//					readVector3(buffer, keyFrame.transform.scale);
				}
				
				output.push(keyFrame);
			}
		}
	}
}